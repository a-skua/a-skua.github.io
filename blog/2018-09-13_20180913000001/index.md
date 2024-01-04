---
layout: layouts/blog.njk
title: 初めてのDockerfile
tags:
  - blog
categories:
  - docker
---

できるだけ長く続けて行きたいなーと思いつつ更新。

最近Dockerを使い始め、 ようやく自分でDockerfileを書けるようになりました。

Goの実行環境を作ったりしてみたのですが、
Dockerfileをbuildするときにソースファイルを読みこんでいました。 こんな感じに…

```dockerfile
FROM golang

WORKDIR /go/src/hello
COPY . .

CMD go build && ./hello
```

ただ、このやり方だと、 ソースを書き直すたびに build
をやり直す必要があるため、なんだか面倒だなーと。 探したところ、docker-compose の
volumes を利用すると上手くいきそう… そういうわけで実装してみました。

```dockerfile
FROM golang
MAINTAINER asuka

WORKDIR /go/src/github.com/19700101000000/system-sample/server

RUN go get -u github.com/golang/dep/...


CMD dep ensure && go build && ./server
```

こんなふうにDockerfileを書いて…

```yaml
version: "3"

services: 
  server: 
    build: server
      volumes: 
        - ./server:/go/src/github.com/19700101000000/system-sample/server
  proxy:
    image: nginx
    volumes:
      - ./proxy/conf.d:/etc/nginx/conf.d
    ports:
      -  80:80
    links:
      - server
```

こんな感じに docker-compose を書く。

動かしてみたところ、Dockerfile を毎度 build し直さなくても上手く動きました。
めでたしめでたし。 ただ、dep init
に関しては、事前にやっておく必要があるので、それを忘れると上手く動きません。
この辺の設定について、また何か良い案があれば載せたいと思います。

実際に作っているリポジトリがあるので、気になる方は
[こちら](https://github.com/a-skua/system-sample) を参照してください。
ただし、アクティブはリポジトリなので、書き換わる可能性がありますが…
