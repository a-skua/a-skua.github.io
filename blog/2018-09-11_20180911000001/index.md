---
layout: layouts/blog.njk
title: Go言語における変数入れ替え
tags:
  - blog
categories:
  - golang
---

ブログサイトとして作っているものの、
このままだと何時になっても公開できそうにないので、ブログ始めます。
ぼちぼち更新出来たらいいな、と。

最近、Go言語を使い始めました。 個人的にかなり良い言語だと思っています。
ブログの最初ということで、Hello,World ネタをやります。 まずは下記のソースを。

```go
package main

import "fmt"

func main() {
	str1, str2 := "hello", "world"
	// var str1, str2 string = "hello", "world"
	fmt.Println(str1, str2)

	str1, str2 = str2, str1
	fmt.Println(str1, str2)
}
```

何をやっているか分かるでしょうか。 出力結果は次のようになります。

```shell
hello world
world hello
```

これは、Go言語における変数の入れ替えです。
他言語からを使っていた私にとってかなりの衝撃でした。

６行目で文字列型の変数を２つ宣言し、 １０行目でその中身を入れ替えています。
７行目のコメントアウトは６行目の宣言を丁寧に書いたものです。
ますますGo言語が好きになりました。
