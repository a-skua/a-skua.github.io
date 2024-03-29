---
layout: layouts/blog.njk
title: "Rust覚書5:enum and pattern matching"
tags:
  - blog
categories:
  - rust
---

列挙型(`enums`)は多くの言語にある機能

しかし、その機能は言語毎に異なっている

Rustの列挙型は、F#, OCaml, Haskellなどの関数型言語の代数データ型に最も似ている

## 列挙型の定義: defining an enum

```rust
enum IpAddrKind {
    v4,
    v6
}
```

### enum values

```rust
let four = IpAddrKind::V4;
let six = IpAddrKind::V6;
```

```rust
struct IpAddr {
    kind: IpAddrKind,
    address: String,
}

let home = IpAddr {
    kind: IpAddrKind::V4,
    address: String::from("127.0.0.1"),
};

let loopback = IpAddr {
    kind: IpAddrKind::V6,
    address: String::from("::1"),
};
```

ここでは、構造体 `IpAddr`は2つのフィールドを定義している

また、２つのインスタンス `home`と `loopback`を作成している
これを、列挙型の要素(`variant`)に直接値を配置することにより、
同じ概念をより簡潔に表現できる

```rust
enum IpAddr {
    V4(String),
    V6(String),
}

let home = IpAddr::V4(String::from("127.0.0.1"));

let loopback = IpAddr::V6(String::from("::1"));
```

これにより、追加の構造体が不要になる

構造体ではなく列挙型を使用するのには別の利点がある

各要素(`variant`と呼ぶ方が良い?)には、異なる型と量の関連データを定義することができる

```rust
enum IpAddr {
    V4(u8, u8, u8, u8),
    V6(String),
}

let home = IpAddr::V4(127, 0, 0, 1);

let loopback = IpAddr::V6(String::from("::1"));
```

次の例では、列挙型のバリアント内にあらゆる種類のデータを定義できることを示す

```rust
struct Ipv4Addr {
    // --snip--
}

struct Ipv6Addr {
    // --snip--
}

enum IpAddr {
    V4(Ipv4Addr),
    V6(Ipv6Addr),
}
```

別の列挙式も含めることが可能

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}
```

この `enum`には、異なる方の4つの `variant`がある

- `Quit`は関連デーが全く存在しない
- `Move`は匿名の構造体(無名構造体)を含んでいる
- `Write`は単一の文字列を含んでいる
- `ChangeColor`は3つの `i32`を含んでいる

`enum`の`variant`で定義することは、 グループ化されていることを除いて、
異なる種類の`struct`を定義することに似ている

```rust
struct QuitMessage; // unit struct
struct MoveMessage {
    x: i32,
    y: i32,
}
struct WriteMessage(String); // tuple struct
struct ChangeColorMessage(i32, i32, i32); // tuple struct
```

しかし、それぞれが独自の方をもつ構造体を使用した場合、
`enum`ほど簡単に受け取る関数を定義出来ない

`enum`の場合、1つの型で定義することができる

列挙型と構造体にはもう1つ類似点がある
`struct`同様、`enum`も`impl`を使用してメソッドを定義できる

```rust
impl Message {
    fn call(&self) {
        // method body would be defined here
    }
}

let m = Message::Write(String::from("hello"));
m.call();
```

## Option EnumとNull値に対する利点: the option enum and its advantages over null values

`option`型は何かの値、またはまったくないという一般的なシナリオをエンコードするため、
多くの場所で使用される

この概念を型システムの観点から表現すると、
処理する必要がある全てのケースを処理したかどうかをコンパイラが確認できる

この機能により、他のプログラミング言語で非常に一般的なバグを防ぐことができる

プログラミング言語の設計は、多くの場合、どの機能を含めるかという観点からがんが得られますが、除外する機能も重要である

Rustには他の多くの言語が持つ `Null`機能がない

nullは値が存在しないことを意味する値...
nullのある言語は変数は常にnullまたはnot-nullのいずれかの状態になる

null値の問題は、null値を非null値として使用しようとすると何らかのエラーが発生することである
(かの有名な「ぬるぽ」の語源とも深いかかわりがあるｶﾞｯ) null or
not-nullは一般的であるため、この主のエラーは非常に簡単

しかし、 nullが表現しようとしている概念は依然として有用である

nullは、現在無効であるか、何らかの理由で存在しない値

問題は実際にはコンセプトにあるのではなく、特定の実装にある

そのため、Rustにはnullがないが、
値の存在または不在の概念をエンコードできる列挙型がある

この`enum`が `Option<T>`であり、標準ライブラリによって次のように定義されている

```rust
enum Option<T> {
    Some(T),
    None,
}
```

この `Option<T>`列挙型は非常に便利なため、すでに含まれている

よって明示的にスコープに入れる必要はない

`variant`も同様に `Option::`宣言なしで `Some`及び `None`を直接使用できる

`<T>`構文はまだ説明していないRustの機能である

(ジェネリック(generic)型)

```rust
let some_number = Some(5);
let some_string = Some("a string");

let absent_number: Option<i32> = None;
```

Someではなく、Noneを使用する場合、Rustに `Option<T>`を伝える必要がある
(例`absent_number`)

これは、コンパイラがNone値を見てもSome
`variant`が保持する型を推測出来ないためである

Some値がある場合、値が存在し、その`Some`内に保持されていることがわかる

`None`がある場合、ある意味で `null`と同じことを意味する
では、なぜ`null`を持つよりも `Option<T>`の方が良いのか?

簡潔に説明すると、`Option<T>`と`T`は異なる型であるため、
コンパイラはの値が有効だった場合でも次のように `Option<T>`を扱うことが出来ない

```rust
let x: i8 = 5;
let y: Option<i8> = Some(5);

let sum = x + y; // error
```

この場合、`Option<T>`を`T`に変換してから、実行する必要がある

これは、`null`の一般的な問題の1つを解決するのに役立つ

`non-null`値を誤って仮定することを心配する必要が無いので、コードに自信を持つことができる

`null`の可能性がある値を設定するには
`Option<T>`を利用して明示的に宣言する必要がある

また、その場合は値が `null`の場合を明示的に処理する必要がある

値の型が `Option<T>`以外の場合、値が`null`ではないと想定できる

これはRustが
`null`の普及を制限し、Rustコードの安全性を高めるという意図的な設計上の決定

`Option<T>`では様々な状況で役立つ多数のメソッドがあるので
[ドキュメント](https://doc.rust-lang.org/std/option/enum.Option.html)
を確認すること

`Option<T>`のメソッドに精通することはRustでの開発に非常に役立つので...

一般的に`Option<T>`の値を使用するには、各`variant`を処理する記述が必要になる

`Some(T)`値がある場合にのみ実行されるコードが必要であり、
このコードは内部のTを使用できる必要がある

None値があり、そのコードにT値がない場合、他のコードを実行する必要がある
`match`式は、`enum`が使用されたときにこれを行う制御フロー構造である

`enum`の`variant`に応じて異なるコードを実行し、そのコードは一致する値内のデータを使用できる

## `match`フロー制御演算子: the match control flow operator

Rustには `match`と呼ばれる非常に協力は制御フロー演算子がある

パターンはリテラル値、変数名、ワイルドカード、その他多くのもので構成できる

様々な種類のパターンとその機能について説明する

`match`の強力さは、パターンの表現力と、考えられる全てのケースがコンパイラが確認するという事実に基づいている

```rust
enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter,
}

fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25,
    }
}
```

`if`に使用される式に非常ににているが、大きな違いがある

`if`の場合、式は`bool`値を返す必要があるが、ここでは任意の型を使用できる

`match`アーム`arms`について

アームにはパターンとコードの2つの部分がある
アームにはパターンとコードを分離する`=>`演算子がある (`pattern`=>`code`)

`match`式を実行した時、結果の値を各アームのパターンと順番に比較する

パターンが値と一致する場合、そのパターンに関連付けられたコードが実行される

各アームに関連付けられたコードは式で、`arm`の式の結果は`match`式全体に対して返される値
`arm`コードが短い場合、通常は中括弧を使用しないが、
アーム内で複数行のコードを実行する場合は、中括弧を使用できる

```rust
fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => {
            println!("Lucky penny!");
            1
        },
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter => 25,
    }
}
```

## 値にバインドするパターン: patterns that bind values

`match`アームの他の便利な機能として、
パターンに一致する値の部分にバインドできることがある

```rust
#[derive(Debug)] // so we can inspect the state in a minute
enum UsState {
    Alabama,
    Alaska,
   // --snip--
}

enum Coin {
    Penny,
    Nickel,
    Dime,
    Quarter(UsState),
}
```

```rust
fn value_in_cents(coin: Coin) -> u8 {
    match coin {
        Coin::Penny => 1,
        Coin::Nickel => 5,
        Coin::Dime => 10,
        Coin::Quarter(state) => {
            println!("State quarter from {:?}!", state);
            25
        },
    }
}
```

`value_in_cents(Coin::Quarter(UsState::Alaska))`を呼び出した場合、
`Coin::Quarter(state)`アームに到達するまで、いずれにも`match`しない

## `Option<T>`とのマッチング: matching with Option&lt;T&gt;

`Option<T>`を使用する場合、`Some`から`T`を取得知ったかったはずである

`enum Coin`の例のように、 `match`式を使うことで`Option<T>`を使うこともできる

```rust
fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        None => None,
        Some(i) => Some(i + 1),
    }
}

let five = Some(5);
let six = plus_one(five);
let none = plus_one(None);
```

`match`と`enum`を組み合わせると、多くの状況で役立つ

このパターンはRustのコードではよく見られる

## `match`式は徹底的である: matches are exhaustive

`match`式は、`enum`型の`variant`を全て書かなかった場合、コンパイルエラーになる

よって、次の場合はエラーとなる

```rust
fn plus_one(x: Option<i32>) -> Option<i32> {
    match x {
        Some(i) => Some(i + 1),
    }
}
```

## `_`プレースホルダー: the _ placeholder

Rustには全てのパターンを並べたくないときに使用できるパターンもある

```rust
let some_u8_value = 0u8;
match some_u8_value {
    1 => println!("one"),
    3 => println!("three"),
    5 => println!("five"),
    7 => println!("seven"),
    _ => (),
}
```

上記は1, 3, 5, and 7のみしか値を使わない時の例である

`_`パターンは、任意の値に`match`する

他のアームの最後に置くことで、
`_`はそれ以前に指定されていない可能性のある全てのパターンと一致する

`()`は単なる `unit`値であるため、 `_`の場合は何も起こらない

ただし、１つのパターンだけに注意しないといけない状況では、`match`表現は少し冗長になる

この場合、Rustは `if let`を提供する

## `if let`を使用した簡潔な制御フロー: concise control flow with `if let`

`if let`構文を使用すると、`if`と`let`を組み合わせて1つのパターンに一致する値を処理し、
残りを全て無視するより冗長な方法にすることができる

```rust
let some_u8_value = Some(0u8);
match some_u8_value {
    Some(3) => println!("three"),
    _ => (),
}
```

```rust
if let Some(3) = some_u8_value {
    println!("three");
}
```

`if let`構文は、等号で区切られたパターンと式を取る (let pattern = expression)

`if let`構文を使用すると、タイピングやインデント、定型コードが少なくなるかわりに、

`match`式が強制するような徹底的なチェックがなくなる

簡潔さと徹底的ｎチェックはトレードオフである

`if let`は1つのパターンに一致し、他の全ての値を無視するときになどに適しているとも言える

`if let`構文は、`else`を含めることができる

```rust
let mut count = 0;
match coin {
    Coin::Quarter(state) => println!("State quarter from {:?}!", state),
    _ => count += 1,
}
```

```rust
let mut count = 0;
if let Coin::Quarter(state) = coin {
    println!("State quarter from {:?}!", state);
} else {
    count += 1;
}
```

## 要約

標準ライブラリーの`Option<T>`型が、
型システムを使用してエラーを防ぐ方法を紹介した

列挙値にデータがある場合、処理する必要があるケースの数に応じて
`match`または`if let`を使用し、値を抽出して使用できる

## 感想

アーム(`arms`)...腕？

## 参考

- [The Rust Programming Language](https://doc.rust-lang.org/book/ch06-00-enums.html)
