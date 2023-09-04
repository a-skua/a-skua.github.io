---
layout: layouts/blog.njk
title: "Linuxで始めるOS自作入門: 2日目"
tags:
  - blog
categories:
  - OS自作入門
---

今回の内容は次の通り

1. アセンブリを書いてみよう
1. アセンブリを書くにあたってのCPUとメモリの簡単な解説をするよ
1. ブートセクタはOSの実行ファイルから切り離そう

特にここで環境的に詰まることはないかな〜と。  
1日目の内容で、開発環境における問題はほぼ解決していると思います。

強いて言うのであれば、 `make` コマンドでしょうか？  


```shell
 $ make run
```

私の場合はすでにコマンドがインストールされていたのですが、
もしない場合は下記のコマンドでインストールしてください。

```shell
$ sudo apt-get install make
```

基本的に、ここで詰まるといった内容はなかったと思いますw