---
layout: layouts/blog.njk
title: "Linuxで始めるOS自作入門: 27日目"
tags:
  - blog
categories:
  - OS自作入門
---

## 内容
1. OSを守ろう
1. Makefile整理

## OSを守ろう
アプリからOSのglobal segmentに対して書き換えが出来ないものの、
アプリからアプリのsegmentは書き換えが出来てしまうのでそれの対策。  
CPUすごい(小並感)

## Makefile整理
os, lib and app毎にdirを分けてbuild周りを色々整理

## 余談
(バグある場所に目星を付けつつも
深刻なバグではないので放置中...)

見た目の変化が無いので省略  
なんだかんだ後3日(3日で終わるとは言っていない)
