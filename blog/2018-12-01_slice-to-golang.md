---
layout: layouts/blog.njk
title: GolangにおけるSlice・mapの罠
tags:
  - blog
categories:
  - golang
---
Golangはポインターがあるから、
ポインターが来たら **参照型** ！
それ以外は **値** ！！  
楽勝だぜﾋｬｯﾊｰ！！！
って思っていたら詰みましたorz

```golang
var m, n []int

m = make([]int, 3)
n = m

m[1] = 2

fmt.Println(m, n)
```
のとき、
```
[0 2 0] [0 2 0]
```
出力はこうなるよ…という話  
どう見ても参照型ですね…

まじかーってなりましたｗ  
引数に slice のポインタ渡す意味ないじゃん…  
値 (複製) として渡すにはどうしたらいいんだー


## 解決策
```golang
func foo(m *[]int) {
    // ...
}
```
slice の参照渡しをしたい場合、上記は明らかに冗長なので、下記のようになります
```golang
func foo(m []int) {
    // ...
}
```
じゃあ、値渡しはどうしたら良いのかというと、
`copy` を使って複製したら良いらしい  
ただし、複製するには上限が有って、複製先と複製元の長さが一致していないといけないらしい  
どういうことかというと...
```golang
m := make([]int, 3)
n := make([]int, len(m))
copy(n, m)
```
こうなる…  
で、多次元 slice はもう少し厄介...  
２次元 slice を例にすると下記のようになる
```golang
m := [][]int {
    {1, 2, 3},
    {1, 2, 3},
    {1, 2, 3},
}
n := make([][]int, len(m))
for i := range m {
    n[i] := make([]int, len(m[i]))
    copy(n[i], m[i])
}
```
上記のようにしないと、複製出来ないらしい  
以上

## 参考
[Go言語 スライスの確認](https://qiita.com/mizukmb/items/b543f88bc37c9a75673f)  
[Golangでは可変長なsliceに対してのcopyはできない](https://medium.com/@timakin/golang%E3%81%A7%E3%81%AF%E5%8F%AF%E5%A4%89%E9%95%B7%E3%81%AAslice%E3%81%AB%E5%AF%BE%E3%81%97%E3%81%A6%E3%81%AEcopy%E3%81%AF%E3%81%A7%E3%81%8D%E3%81%AA%E3%81%84-5cf1c8b852c2)  
[go言語のmap、sliceのコピー](https://kido0617.github.io/go/2016-08-08-map-copy/)  
[Golang multidimensional slice copy](https://stackoverflow.com/questions/45465368/golang-multidimensional-slice-copy)
