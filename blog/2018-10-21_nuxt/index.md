---
layout: layouts/blog.njk
title: nuxt.js の Docker 環境構築
tags:
  - blog
categories:
  - nuxt.js
  - docker
---

nuxt.js の Docker 環境構築をやっていたのですが、
色々と上手くいかず…

`git clone` をして Docker 環境を立てるだけで全て整うというのが理想なのですが…

``` dockerfile
FROM node

WORKDIR /app

ENV HOST 0.0.0.0

CMD npm run dev
```

最終的にこの形に収まりました。

## 試行錯誤

```dockerfile
FROM node

WORKDIR /app

COPY ./package.json ./

RUN npm install -g vue-cli && \
	npm install -g nuxt && \
	npm install

ENV HOST 0.0.0.0

CMD npm run dev
```

[nuxt.jsのインストールガイド](https://ja.nuxtjs.org/guide/installation)
に従いローカルで上手く行ったため、同じようにうまくいかないのかな？と。
**スクラッチから始める**
を参考に行ったのですが、上手くいかず…

おそらく `package.json` の中身が足りなかったのだと思いますが、
`webpack` への知見がまだ足りず…

この方法の場合、
**スターターテンプレート**
を使った方法では上手くいきました。
その場合だと、
`npm install -g nuxt`
の一文が不要になります。

```dockerfile
FROM node

WORKDIR /app

COPY ./package.json ./

RUN npm install -g vue-cli && \
	npm install

ENV HOST 0.0.0.0

CMD npm run dev
```

ですが、
`docker-compose` を利用して
`volume`
にて必要なファイルを渡す場合、必要なものを全て渡すのであれば良いのですが、
`volumes: ./ ./` のように書いてしまうと、上手く動かなくなります:(

これは望んでた結果では無いです。

色々考えたのですが、
現状ローカル環境に **node.js**
を入れていて、 `npm install`
を実行出来ているため、DockerのBuild時に色々追加しなくても良いのでは無いかと。

結果、一番最初の形に落ち着きました。

## 代案

今回はこの形に落ち着きましたが、
Dockerを使うのであれば、
やはりローカルに依存しないようにしたいです。

なので、代案としては **Shell script**
を利用するのが良いのではないか？と考えています。

また発展があればまた上げます。

これの方が良いよ！
という案があればツイッターで教えていただけると嬉しいです。

## おまけ

書きかけの記事がいくつかあるので、
早めに書き上げるようにします…
