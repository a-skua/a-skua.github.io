---
layout: layouts/blog.njk
title: Makefileにてshell scriptを書くときの注意
tags:
  - blog
categories:
  - makefile
---

Makefile に shell script を書く場合をこうするんだよというメモ

```makefile
foo:
	for i in 0 1 2 3 4 5 6 7 8 9;\
	do\
	echo $$i;\
	done
```

注目する点は、 `$$i` という感じに `$` を２重に書いているところ

どうも、単に `$i` とだけ書いてしまうと、Makefile の変数として認識するらしい

参考先は[こちら](https://beiznotes.org/multiple-lines-in-makefile/)
