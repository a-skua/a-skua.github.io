---
layout: layouts/blog.njk
title: Goにおける排他制御の挙動
tags:
  - blog
categories:
  - golang
---

## はじめに

排他制御とは、 ある資源にアクセスするときに
自分以外が同時にアクセスしないようにする制御のこと

Goでいうと、 `sync`package を利用して次のように実現出来る

```golang
var num int

func mutex() {
	var mtx sync.Mutex
	mtx.Lock()
	num++
	mtx.Unlock()
}
```

ここで疑問に思ったのが、 `mtx.Lock()`は何を Lock しているのか? ということ

1. 資源のLockを行うということは、 この時`num`を Lock しているのか?
1. もし、`num`を Lock するのであれば、 どうやって `num`を Lock しているのか?
1. `sync.Mutex`に Scope があって、 その範囲にあるものを Lock しているのか?

## 確かめてみる

試しにこんなコードを用意してみた

※ 試行錯誤の結果にできた検証用コードなので、かなり賢いコードになってしまっている

```golang
func mutex(num *int, wg *sync.WaitGroup, mtx *sync.Mutex) {
        if wg != nil {
                defer func() {
                        wg.Done()
                }()
        }
        if mtx != nil {
                mtx.Lock()
                defer func() {
                        mtx.Unlock()
                }()
        }
        if num != nil {
                *num++
        }
}
```

まずは、Lockしないコードで確認

```golang
func main() {
        var num int
        var wg sync.WaitGroup
        for i := 0; i < 10000; i++ {
                wg.Add(1)
                go mutex(&num, &wg, nil)
        }
        wg.Wait()
        fmt.Println(num)
}
```

```shell
7783
```

結果は期待通り `10000`にはなってくれていない

次にLockしてみる

```golang
func main() {
        var num int
        var wg sync.WaitGroup
        var mtx sync.Mutex
        for i := 0; i < 10000; i++ {
                wg.Add(1)
                go mutex(&num, &wg, &mtx)
        }
        wg.Wait()
        fmt.Println(num)
}
```

```shell
10000
```

ここまで期待通り

もう一つループを増やす...

```golang
func main() {
        var num int
        var wg sync.WaitGroup
        var mtx sync.Mutex
        for i := 0; i < 10000; i++ {
                wg.Add(1)
                go mutex(&num, &wg, &mtx)
        }

        for i := 0; i < 10000; i++ {
                wg.Add(1)
                go mutex(&num, &wg, nil)
        }
        wg.Wait()
        fmt.Println(num)
}
```

```shell
18582
```

ここで、排他制御をしている対象に対して
外から制御を行わないアクセスは可能なことが判明

```golang
func main() {
        var num int
        var wg sync.WaitGroup
        var mtx sync.Mutex
        for i := 0; i < 10000; i++ {
                wg.Add(1)
                go mutex(&num, &wg, &mtx)
        }

        for i := 0; i < 10000; i++ {
                wg.Add(1)
                go mutex(&num, &wg, &mtx)
        }
        wg.Wait()
        fmt.Println(num)
}
```

```shell
20000
```

同じ `mutex`を渡すと期待通りになる

ここで、与える `mutex`を変更してみる...

```golang
func main() {
        var num int
        var wg sync.WaitGroup
        var mtx sync.Mutex
        for i := 0; i < 10000; i++ {
                wg.Add(1)
                go mutex(&num, &wg, &mtx)
        }


        var mtx2 sync.Mutex
        for i := 0; i < 10000; i++ {
                wg.Add(1)
                go mutex(&num, &wg, &mtx2)
        }
        wg.Wait()
        fmt.Println(num)
}
```

```shell
19997
```

これが一見うまく行っているように見えたのだが、 2つの
`mutex`が競合していることが判明

## 推測

これらのことから、 `mutex`が Lockをしているのは対象の値ではなく
`mutex`自身であると推測

`mutex`が Lock をしようとしたときに、 すでに Lock されている場合は Unlock
されるのをひたすら待つという感じになる

よく例としてglobal変数に対して Lock をして〜というのがあるけど、
これは非常にまずい状態なのではないかなと

本当に排他制御で値を管理するには値を隠蔽して `setter` and `getter`を使って
その中で必ず排他制御されるようにしないといけないはず

(だから `redux` なんてものがあるのかとこの時納得)

※あくまで挙動からの勝手な想像なのに注意

真実を知るために我々は密林の奥地へと進むことにした...

## 余談

このコードは順次処理も出来る (意味があるわけではない)

```golang
func main() {
        var num int
        var wg sync.WaitGroup
        var mtx sync.Mutex
        for i := 0; i < 10000; i++ {
                wg.Add(1)
                go mutex(&num, &wg, &mtx)
        }

        mtx2 := &mtx
        for i := 0; i < 10000; i++ {
                wg.Add(1)
                go mutex(&num, &wg, mtx2)
        }
        wg.Wait()

        for i := 0; i < 10000; i++ {
                mutex(&num, nil, nil)
        }
        fmt.Println(num)
}
```

```shell
30000
```

ちなみに、godocには次のように記載されている

> A Mutex must not be copied after first use.
