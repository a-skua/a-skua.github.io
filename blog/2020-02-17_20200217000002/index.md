---
layout: layouts/blog.njk
title: Rust覚書2
tags:
  - blog
categories:
  - rust
---

- インデントはスペース4つ
- 定数は大文字アンダースコア繋ぎ
- アンダースコアは数字の可読性向上にも利用可能 (`1_000_000` same `1000000`)
- マクロ呼び出しに `!`を使う(`println!` はマクロ)
- 宣言したけど、使わない変数名にはアンダースコアを付ける

## 関数

関数はスネーク記法で記述する

```rust
fn main() {
    another_funcion(5, 5, 5.4);
}

fn another_funcion(x: i32, y: u32, z: f32) {
    println!("x: {}, y: {}, z: {}", x, y, z);
}
```

## ステートメント: statement

なにかを実行して、値を返さないもののことを指すらしい

rustでは変数宣言が `statement` に該当する

値を返さないため、 `C` や `Ruby` のような `x = y = 6` といった記述は出来ない

```rust
let x = (let y = 6); // compile error
```

## 式: expression

なにかを評価するのが式

rust のほとんどは式で構成されている

関数などが式に該当する

`5 + 6` は式であり、 `11`と評価される

```rust
let x = 5;
let y = {
    let x = 3;
    x + 1 // do not include ending semicolons.
};
println!("{}", y); // 4
```

式にはセミコロンは含まれない

式の最後にセミコロンを付けると、それはステートメントになり、値が返されなくなる

なんかややこしいけど、 最後にセミコロンを付けなかった値が `return`
されるという認識で合っていると思う

評価って言葉が良くないかも

## 返り値付きの関数

返り値の指定には矢印(`->`)を使う

```rust
fn five() -> i32 {
    5 // do not include ending semicolons.
}

fun main() {
    let x = five();
    println!("{}", x);
}
```

値を返す場合、うっかりセミコロンを付けると空のタプルが返ってコンパイルエラーとなる

ちゃんとエラーメッセージでヒントが出るので、ちゃんとエラーメッセージを読もう(戒

## if式

ごく普通の `if`って印象

```rust
let number = 3;

if number < 5 {
    println!("foo");
} else if number == 5 {
    println!("five!");
} else {
    println!("bar");
}
```

条件は `bool` である必要があり、 `Ruby` や `JavaScript` のように
`bool`ではない型を自動変換しようとはしない

### if は式である

式なのでステートメント `let`の右側で使える

```rust
let condition = true;
let number = if condition {
    5
} else {
    6
};
```

ただし、型は一致させること

コンパイル時に型が不明確だとエラーになる

## 繰り返し処理

`loop`, `while` and `for`の3つがある

### loop

```rust
loop {
    println!("loop!");
}
```

`break`で抜けられる

また `break`には値を返す機能もある

```rust
let mut counter = 0;

let result = loop {
    counter += 1;

    if counter == 10 {
        break counter * 2;
    }
};
```

おそらく、式とは別もの?

breakは式らしい?

### while

ごく一般的なやつ

ただし、 `loop`のような `let`宣言にはどうも使えないっぽい

```rust
let mut number = 3;

while number > 0 {
    println!("{}!", number);

    number -= 1;
}
```

### for

ごく一般的なやつ

配列で使うと非常に有効

```rust
let a = [10, 20, 30, 40, 50];

for element in a.iter() {
    println!("the value is: {}", element);
}
```

または、特定の回数繰り返し

```rust
// 1 <= n < 4
for number in 1..4 {
    println!("{}!", number);
}

// 1 <= n <= 4
for number in 1..=4 {
    println!("{}!", number);
}

// 4 > n >= 1
for number in (1..4).rev() { // reverse
    println!("{}!", number);
}
```

## 参考

- [The Rust Programming Language: 3.3. Functions](https://doc.rust-lang.org/book/ch03-03-how-functions-work.html)
- [The Rust Programming Language: 3.5. Control Flow](https://doc.rust-lang.org/book/ch03-05-control-flow.html)
