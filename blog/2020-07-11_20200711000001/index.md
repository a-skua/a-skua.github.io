---
layout: layouts/blog.njk
title: Goにおける排他制御の実装
tags:
  - blog
categories:
  - golang
---

## あらすじ

なんやかんやあって前回の続き...

実装を調べるところまでを1つの記事にしようとしていたのだけど、
それだと何時まで経っても出せないということで分割

## 実装を読む

前回の推測が正しいか、 実装を見て確かめることにする

### sync.Mutex

```golang
type Mutex struct {
    state int32
    sema  uint32
}
```

Mutex の中身はこんな感じになっている

名前的に `Mutex.state` が怪しい

```golang
func (m *Mutex) Lock() {
    if atomic.CompareAndSwapInt32(&m.state, 0, mutexLocked) {
        if race.Enabled {
            race.Acquire(unsafe.Pointer(m))
        }
        return
    }
    m.lockSlow()
}
```

Lockの中身...

`atomic`, `race` and `unsafe` は名前から推測出来るけど、
使ったことが無いので順に見ていく

名前的にも `atomic` がキーな気がする

### flags

```golang
const (
    mutexLocked = 1 << iota // 1
    mutexWoken              // 2
    mutexStarving           // 4
    mutexWaiterShift = iota // 3
)
```

package内で使われている flags

```golang
const (
    a = iota // 0
    b        // 1
    c        // 2
    d        // 3
)
```

`iota`はよく enum のような意味合いで利用されるが、
これにシフト演算を組み合わせて flagsにしている (こんな使い方があるのか)

### sync/atomic

この package は assembly で実装されている

探し出して比較的読みやすいと思われる x86 の 処理を見てみると LOCK
接頭語が使用されている (排他制御、お前だったのか)

どんな命令か気になる人は [この辺](https://www.felixcloutier.com/x86/lock)
とかを読んでみて

[atomic.CompareAndSwapInt32](https://github.com/golang/go/blob/50bd1c4d4eb4fac8ddeb5f063c099daccfb71b26/src/runtime/internal/atomic/asm_386.s#L14)
`0` と `&m.state` を比較して、 等しければ `mutexLocked` を `&m.state`
に書き込み、成否を返すというもの

つまり、ロック出来たときに if分岐の中に入れる

```golang
var num int32

func main() {
    var wg sync.WaitGroup

    for i := 0; i < 20000; i++ {
        wg.Add(1)
        go func() {
            atomic.AddInt32(&num, 1)
            wg.Done()
        }()
    }
    wg.Wait()
        fmt.Println(num)
}
```

```shell
20000
```

`sync/atomic`を使うと、こんな処理を書くことが可能になる

### internal/race

`rage.Enabled`の実装

```golang
const Enabled = false
```

ん??

推測... const になっていることから、goのsourceからは書き換えられないが、
runtimeとなるasm側で書き換えている可能性が大

ってことで見ていく...

全然違った

```golang
// +build !race
const Enable = false
```

```golang
// +build rage
const Enable = true
```

> Package race contains helper functions for manually instrumenting code for the
> race detector.

どうもこれは競合を検出するための分岐らしい

```shell
go run -race main.go
```

こんな感じに書くと...

```shell
==================
WARNING: DATA RACE
Read at 0x00c0000b8010 by goroutine 8:
  main.mutex()
      /home/asuka/GoProjects/sample-mutex/main.go:21 +0x8e

Previous write at 0x00c0000b8010 by goroutine 7:
  main.mutex()
      /home/asuka/GoProjects/sample-mutex/main.go:21 +0xa7

Goroutine 8 (running) created at:
  main.main()
      /home/asuka/GoProjects/sample-mutex/main.go:31 +0x13b

Goroutine 7 (finished) created at:
  main.main()
      /home/asuka/GoProjects/sample-mutex/main.go:31 +0x13b
==================
29744
Found 1 data race(s)
exit status 66
```

競合が発生した場合にこんな警告出る

これは便利そうなので debug とかで使っていきたい

### unsafe

`race.Enabled`はひとまず自分の関心から無視して良いことがわかったが、 `unsafe`
は気になる所...

```golang
package unsafe

type Pointer *ArbitraryType
```

`unsafe.Pointer(m)`は cast (覚えた)

godocにはこんなことが記載されている

- A pointer value of any type can be converted to a Pointer.
- A Pointer can be converted to a pointer value of any type.
- A uintptr can be converted to a Pointer.
- A Pointer can be converted to a uintptr.

その名の通りポインターらしい

試してみる

```golang
func main() {
    var a [8]uint8
    for i := range a {
        a[i] = 1 << i
    }
    fmt.Println(a)
}
```

```shell
[1 2 4 8 16 32 64 128]
```

今回は slice ではなく配列を用意

#### A pointer value of any type can be converted to a Pointer.

```golang
func main() {
    var a [8]uint8
    for i := range a {
        a[i] = 1 << i
    }
    fmt.Println(a)

    p := unsafe.Pointer(&a)
    fmt.Println(p)
}
```

```shell
[1 2 4 8 16 32 64 128]
0xc0000b6000
```

任意の型の `pointer` は `Pointer`に cast 出来ますよ、と

#### A Pointer can be converted to a pointer value of any type.

```golang
func main() {
    var a [8]uint8
    for i := range a {
        a[i] = 1 << i
    }

    p := unsafe.Pointer(&a)

    p8 := (*uint8)(p)
    p16 := (*uint16)(p)
    p32 := (*uint32)(p)

    fmt.Println(*p8)
    fmt.Println(*p16)
    fmt.Println(*p32)
}
```

```shell
1
513
134480385
```

`Pointer` から任意の型の `pointer` にキャスト出来る

ただし、この結果は期待と少々違った結果になった

期待した出力結果...

```shell
1
258
66052
```

これはCPUのデータ格納形式の違いによるものという結論に...

`uint8[1 2 4 ...]` というのをbitsに直すと次のようになる

```shell
00000001
00000010
00000100
...
```

`1, 258, 66052` という出力結果はこのbytesを上から結合したもの

```shell
00000001                    // 1
00000001 00000010           // 258
00000001 00000010 00000100  // 66052
```

逆に、 `1, 513, 134480385` というのはbitsを下から結合していったもの

```shell
00000001                    // 1
00000010 00000001           // 513
00000100 00000010 00000001  // 134480385
```

なぜこうなるかというと、これはCPUによって異なるもので... 詳しくは `big endian`,
`little endian` で調べよう

良い子は間違っても `unsafe.Pointer`を利用してcastをしてはいけない

#### A uintptr can be converted to a Pointer.

Go にはポインターの値を格納するための `uintptr` 型がある (今回始めて知った)

`uintptr`は`Pointer`にcast出来ますよ、と

```golang
func main() {
    var addr uintptr
    p := (*uint8)(unsafe.Pointer(addr))
    fmt.Println(*p)
```

```shell
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x0 pc=0x48d277]

goroutine 1 [running]:
main.main()
        /home/asuka/GoProjects/sample-mutex/main.3.go:34 +0x357
exit status 2
```

良い子は真似してはいけない

#### A Pointer can be converted to a uintptr.

もちろん、逆も出来る

```golang
func main() {
    var a [8]uint8
    for i := range a {
        a[i] = 1 << i
    }

    p := unsafe.Pointer(&a)
    addr := uintptr(p)
    fmt.Println(addr)
}
```

```shell
824633811272
```

ここまで出来ると、当然ながら ポインターを使った計算が出来るわけで...

```golang
func main() {
    var a [8]uint8
    for i := range a {
        a[i] = 1 << i
    }
    fmt.Println(a)

    p := unsafe.Pointer(&a)

    addr := uintptr(p)
    for i := range a {
        p8 := (*uint8)(unsafe.Pointer(addr + uintptr(i)))
        fmt.Println(*p8)
    }
}
```

```shell
[1 2 4 8 16 32 64 128]
1
2
4
8
16
32
64
128
```

間違っても良い子は配列操作のために `Pointer` を使ってはいけない

```golang
for i := 0; i < 10000; i++ {
    p8 := (*uint8)(unsafe.Pointer(addr + uintptr(i)))
    *p8 = 0
    fmt.Println(*p8)
}
```

こんな感じのコードを書くと、当然ながらpanicする

```shell
panic: runtime error: invalid memory address or nil pointer dereference
[signal SIGSEGV: segmentation violation code=0x1 addr=0x0 pc=0x482962]

goroutine 1 [running]:
os.(*File).write(...)
        /usr/local/go/src/os/file_unix.go:276
os.(*File).Write(0xc0000ac008, 0xc0000b4000, 0x2, 0x20, 0x0, 0x4db680, 0xc00008a1b0)
        /usr/local/go/src/os/file.go:153 +0x42
fmt.Fprintln(0x4db660, 0xc0000ac008, 0xc000092f10, 0x1, 0x1, 0x0, 0x4db680, 0xc00008a1b0)
        /usr/local/go/src/fmt/print.go:265 +0x8b
fmt.Println(...)
        /usr/local/go/src/fmt/print.go:274
main.main()
        /home/asuka/GoProjects/sample-mutex/main.3.go:44 +0x47d
exit status 2
```

サイズを超えたアクセスは無効と書かれているけど、
別にコンパイルエラーになるわけでは無いらしい

> Unlike in C, it is not valid to advance a pointer just beyond the end of its
> original allocation:

C言語と異なるのは、 ポインターに対して直接の計算が出来ないことと、
アドレスへの計算になるため、 +1 したら番地が 1進むだけで
Cのように次の要素分だけアドレスが進んでくれるわけではないということ (今回は
8bits sizeのデータを扱っているからうまくいっている)

## まとめ

思ったよりも長くなってしまったのでこの辺で一区切り 次は
`func (m *Mutex) lockSlow()`を見ていく (予定)
