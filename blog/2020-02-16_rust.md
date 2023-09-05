---
layout: layouts/blog.njk
title: Rust覚書
tags:
  - blog
categories:
  - rust
---

Rustを触ってみたのでその覚書

## 変数

変数には、可変と不変が有り、基本は不変

```rust
// immutable
let x = 10;
x = 5 // compile error
```

```rust
// mutable
let mut x = 10;
x = 5; // ok
```

また、参照渡の場合も、基本は不変であるため、可変の場合は明記する必要がある

`Java` や `Dart` で言う所の `final`かな

```rust
let mut x = 10;

// immutable
foo(&x);

// mutable
foo(&mut x);
```

### Shadowing

変数名を使いまわして使うことが可能

`guess_str`, `guess_num`とするところを、 `guess`のみで利用可能

変数を上書きするため、型も変更可能

`JavaScript` や `PHP` のどんな型でも入る性質とは別物なのに注意

型は一意に定まる

同じ変数名で宣言し直しているだけ

```rust
let mut guess = String::new();

io::stdin().read_line(&mut guess)
    .expect("Failed to read line");

let guess: u32 = guess.trim().parse()
    .expect("Please type a number!");

println!("You guessed: {}", guess);
```

## 定数

可変変数とは別に定数も存在している

可読性のために数値に `under score` を付けることも可能

```rust
const MAX_POINTS = 1_000_000;
```

## 整数

`arch` はアーキテクチャ依存

`go` で言う所の `int`, `uint`に当たる

| Length | Signed | Unsigned |
| --- | --- | --- |
| 8-bit | i8 | u8 |
| 16-bit | i16 | u16 |
| 32-bit | i32 | u32 |
| 64-bit | i64 | u64 |
| 128-bit | i128 | u128 |
| arch | isize | usize |

Rust の整数型のデフォルトは `i32`で、
`64-bit`環境でも最速らしいので困ったら `i32`

`isize` や `usize` はインデックスの作成などでよく使うらしい

## 浮動点少数

`f32` と `f64`があり、
デフォルトは `f64`

最新CPUにおいてほぼ等速なため、精度の高い `f64`を採用したとのこと

## 真偽

`bool` は1バイトらしい(1bitとかじゃないみたい)
多分 `go`とかも 1bitじゃ無いんだろうなー(試してないけど)

## 文字

文字列は `double quote`, 文字は `single quote`

文字型は4バイトで、Unicode対応(とても良い)

`go` の `rune` に相当

絵文字や日本語にも対応している(良き)

```rust
let c = 'z';
```

ただし、 `charactor != Unicode` らしい
なんか違うみたい

## 複合型

配列とタプルなるものがある

### Tuple

タプルは列挙する型が同じでなくても良い

```rust
let tup: (i32, f64, u8) = (500, 6.4, 1);

let (x, y, z) = tup;

let five_hundred = tup.0;
let one = tup.2;
```

### 配列

配列は列挙する方が同じである必要がある

また、rustの配列は固定長である

```rust
let a = [1, 2, 3, 4, 5];
let months = ["Jan", "Feb"];

// type; number
let a: [i32; 5] = [1, 2, 3, 4, 5];

// initialize; number
let a = [3; 5]; // same [3, 3, 3, 3, 3]

let first = a[0];
```

## 演算
基本的に同じ型同士しか出来ないみたい

試しに `float` + `integer` したら怒られた

## 参考
- [The Rust Programming Language: 2. Programming a Guessing Game](https://doc.rust-lang.org/book/ch02-00-guessing-game-tutorial.html)
- [The Rust Programming Language: 3.2. Data Types](https://doc.rust-lang.org/book/ch03-02-data-types.html)
