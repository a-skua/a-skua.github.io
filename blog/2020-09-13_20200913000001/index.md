---
layout: layouts/blog.njk
title: "Linuxで始めるOS自作入門: 19日目"
tags:
  - blog
categories:
  - OS自作入門
---

## 内容

1. cat実装
1. FAT対応
1. アプリ

## cat実装

本書ではtypeコマンド実装として扱われているが、
(これはwindowsコマンド風なので)linux風(正しくはUNIX?)
に読み替えてcatコマンドを実装\
実行するとファイルの中身が読めるよーというやつ

## FAT対応

512bytesを超えるファイルは分割されてしまって正しく読めないことがあるので〜(ry\
ちゃんと読めるようにしたよ...
FATってファイルフォーマットの名称だとばっかり思ってたけど、
`File Allocation Table`ってファイルフォーマット名称というよりは仕組みの名前っぽい

## アプリ

アセンブリで起動したらフリーズする処理を書いて呼び出せるように (ウイルスみたい)

## 余談

あんまり代わり映えしないので (ただの横着) スクリーンショットは割愛

前章やったの2週間くらいまえかーと思ってたら 1ヶ月前だっった...\
(`.nas` を `.hrb`にコンパイルすると言われて
どうやるんだっけ？となってたのは秘密)
