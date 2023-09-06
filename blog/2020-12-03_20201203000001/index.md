---
layout: layouts/blog.njk
title: 自作x86エミュレータはじめました
tags:
  - blog
categories:
  - x86エミュレータ
---

`OS自作入門`を終えたので、
`自作エミュレータで学ぶx86アーキテクチャ`という本をはじめました。
よくわかってないですが面白いです。
-完-

OS自作入門は、ひたすらコードを写していたのですが、
自作エミュレータ本は実装をRustで進めることにしました。
正直Rustの実装で何か困っているわけではないのですが、
エミュレータで実行するためのバイナリ生成に手間取っていたので、そのメモ。

## 実行環境

```text
ARCH: amd64
OS: Kubuntu 20.04
NASM: 2.14.02
GCC: 9.3.0
```
例によって実行環境はLinuxになります。

## 実行バイナリ生成
nasmから実行バイナリ生成は特に困ることはないのですが、
Cから実行バイナリ生成が少々厄介。
前半のC言語の説明は復習として読むにとどめて特に実行することはしていなかったのですが、
さすがにnasmとCから生成したバイナリをリンカーでつなげて1つに纏めるような場合はやらないわけにも行かず...

以下、`test.c`と`crt0.asm`から`test.bin`を生成するコマンド

```sh
gcc -nostdlib -m32 -fno-pie -g -fno-stack-protector -c test.c
nasm -f elf crt0.asm
ld --entry-start --oformat-binary -Ttext 0x7c00 -m elf_i386 -o test.bin crt0.o test.o
```

まず、gccオプションには `-m32 -fno-pie`が必要なもよう...
(x86_64環境だからか、i386コードを生成するにはこれが必要)
nasmコマンドのほうは `elf64`を代わりに指定すると `x86_64`のバイナリを吐けるよう。
ただそれすると解説本との差異に自分が対応できるか怪しいため、今回は`i386`に合わせる方針。
ldには、 `-m elf_i386`が必須
(じゃないと`i386`を扱えない)

こうやって生成された `test.bin`が想像以上に大きく合っているのか不安だったんですが、
冒頭の方に想定していたバイナリコードがある
```sh
$ ndiasm -b32 test.bin | less
00000000  E805000000        call 0xa
00000005  E9F683FFFF        jmp 0xffff8400
0000000A  F30F1EFB          rep hint_nop55 ebx
0000000E  55                push ebp
0000000F  89E5              mov ebp,esp
00000011  83EC10            sub esp,byte +0x10
00000014  C745FC28000000    mov dword [ebp-0x4],0x28
0000001B  8345FC01          add dword [ebp-0x4],byte +0x1
0000001F  8B45FC            mov eax,[ebp-0x4]
00000022  C9                leave
00000023  C3                ret
00000024  0000              add [eax],al
00000026  0000              add [eax],al
00000028  0000              add [eax],al
0000002A  0000              add [eax],al
0000002C  0000              add [eax],al
0000002E  0000              add [eax],al
00000030  0000              add [eax],al
00000032  0000              add [eax],al
00000034  0000              add [eax],al
00000036  0000              add [eax],al
00000038  0000              add [eax],al
0000003A  0000              add [eax],al
0000003C  0000              add [eax],al
...
```
生成できたのは良かったものの、
3行目の `F30F1EFB(rep hint_nop55 ebx)`の意味がわからず...

## endbr64

`F30F1EFB`は`end branch 64`という命令らしく、
安全に実行するための仕組みらしいのですが、
インテルのマニュアル読んでもよくわからず&今回の実装では必要なさそうだったので無視することに

```rust
pub fn endbr64(emu: &mut Emulator) {
    emu.eip += 4;
}
```

こんな感じの実装を用意して `0xF3`に割当
(ちなみにここの処理を `+= 5`と間違っていたために悶々と悩んでいた)

これでめでたくコードを実行出来たのでヨシ(EBPが0ではないのが気になるが...EAXが合っているので一旦放置)

```text
EIP = 0x00007C00, CODE = 0xE8
EIP = 0x00007C0A, CODE = 0xF3
EIP = 0x00007C0E, CODE = 0x55
EIP = 0x00007C0F, CODE = 0x89
EIP = 0x00007C11, CODE = 0x83
EIP = 0x00007C14, CODE = 0xC7
EIP = 0x00007C1B, CODE = 0x83
EIP = 0x00007C1F, CODE = 0x8B
EIP = 0x00007C22, CODE = 0xC9
EIP = 0x00007C23, CODE = 0xC3
EIP = 0x00007C05, CODE = 0xE9

end of program.

EAX = 0x00000029
ECX = 0x00000000
EDX = 0x00000000
EBX = 0x00000000
ESP = 0x00007C00
EBP = 0x00000029
ESI = 0x00000000
EDI = 0x00000000
EIP = 0x00000000
```

## Rustらしく

久しぶりにRust書いてみたら全然覚えていなくて悶絶。
Cだと`[u8;4]`に対して `u32`を直接代入みたいなことが許されるけど、`Rust`だとできないからねーみたいな。。

```rust
pub fn set_memory32(&mut self, addr: usize, value: u32) {
    for i in 0..4 {
        self.set_memory8(addr + i, value >> (i * 8));
    }
}
```

```rust
pub fn set_memory32(&mut self, addr: usize, value: u32) {
    let mut i = 0;
    for v in value.to_le_bytes().iter() {
        self.set_memory8(addr + i, *v);
        i += 1;
    }
}
```

悶々と悩みつつシフト演算の部分とかを、Rustのメソッド使ってみたりしてました。

## 逆アセンブル

今回、ミスに気がつけたのは逆アセンブルした結果とエミュレータ実行時のレジスタの値を突き合わせてみたおかげだったので、
もし詰まってるようだったら面倒臭がらずにやってみよう。
(修正するなら今のうちだぞ!)
