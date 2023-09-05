---
layout: layouts/blog.njk
title: flexboxでの等間隔配置
tags:
  - blog
categories:
  - css
---

等間隔表示をしたいなぁと思いflexboxを使ったのですが、
想像しているのと違った。

```scss
.paginator {
	display: flex;
	&>p {
		flex-grow: 1;
	}
}
```

見た感じだとこれで上手く行くだろう…
なんておもってたら、そんなことはなく…

> フレックスコンテナー内の利用可能な空間のうち、
どれだけがそのアイテムに割り当てられるかを指定します。
>
> [MDN web docs](https://developer.mozilla.org/ja/docs/Web/CSS/flex-grow)

多分この一文なんだと思うのだけど、
どうもこの `flex-grow` というのは、どうも文字の長さを除いて、
空いている隙間の割当を指定しているみたい。

空き空間は等間隔で割り振っているのだけど、
文字は等間隔でないので全体が等間隔ににならない…

求めているのは全体が等間隔になること…

```scss
.paginator {
	display: flex;
	&>p {
		width: 0;
		flex-grow: 1;
	}
}
```

結果的にはこれで解決。

全ての横幅を0にすることにより、
結果的に全体を等間隔に。

とりあえずはこれで良いのではなかろうか。
