---
layout: layouts/blog.njk
title: "Linuxで始めるOS自作入門: 16日目"
tags:
  - blog
categories:
  - OS自作入門
---

- マルチタスク2
- GDT

## マルチタスク2
前回の着手したマルチタスクの改良  
具体的には優先順位を付けただけ(完)  
ひとまずこんな感じ  

![OSの画像](os-16day.png)  

ここでは次の４つのタスクが動いている
1. メインタスク
   - デスクトップ
   - マウス
   - キーボード
   - アクティブウィンドウ(task_a)
1. task_b0
1. task_b1
1. task_b2

## GDT
昔の内容過ぎて、GDTって何？ってなっていたのでおさらい
> GDTとは`Grobal segment Descriptor Table`の略  
セグメンテーションとは、メモリを好きなように切り分けて、
その最初の番地を0として扱える機能  

(OS自作入門 p.112より引用)

完全に理解した
