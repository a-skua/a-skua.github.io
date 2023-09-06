---
layout: layouts/blog.njk
title: "Linuxで始めるOS自作入門: 17日目"
tags:
  - blog
categories:
  - OS自作入門
---

- idle
- コンソール
- 大文字/小文字, Shift, CapsLock...

## idle
何もしていないときにidle状態にしましょうねーというもの  
ビフォー・アフター  

![idle前](os-17day-idle-before.png)  

![idle後](os-17day-idle-after.png)  

CPU使用率が下がっていることを確認(ヨシ)

## コンソール
前回の要領で別タスクのコンソールを用意

![コンソール](os-17day-console.png)  

## 大文字/小文字, Shift, CapsLock...
あとはメインタスクで受け取った入力をコンソールへ流したり、
Shift, CapsLockなどを有効にしたり等など

![shit有効化](os-17day-char-1.png)  

![capslock有効化](os-17day-char-2.png)  
