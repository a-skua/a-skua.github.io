---
layout: layouts/blog.njk
title: "note: 自作x86エミュレータ.vol3"
tags:
  - blog
categories:
  - x86エミュレータ
---

## note

よくわからずにRustを書いている...

```text
h
>hello
w
>world
q
>
end of program.

EAX = 0x00000071
ECX = 0x00000000
EDX = 0x000003F8
EBX = 0x00000000
ESP = 0x00007C00
EBP = 0x00000000
ESI = 0x00007C4F
EDI = 0x00000000
EIP = 0x00000000
```

期待する値は下記のものなのですが...
Rustは改行が入るまで`flush`されないのでしょうか..?
`print!("{}", ...)`はうまく行かず...
`print!("{}\n", ...)`, `println!("{}")`はうまく行く..

```text
>h
hello
>w
world
>q

end of program.
```

またわかったら書くかもしれない
