---
layout: layouts/blog.njk
title: "Rust覚書10: トレイト(Traits)"
tags:
  - blog
categories:
  - rust
---

## 共有動作の定義: defining shared behavior

トレイトは、特定の型が持つ機能についてRustコンパイラに伝え、 他の型と共有できる

トレイトを使用して、共有の動作を抽象的な方法で定義できる

トレイトの境界を使用して、ジェネリックが特定の動作を持つ任意の型に
できることを指定できる

トレイトは、細かい違いはあるが、他の言語でインターフェースと呼ばれることが
多い機能に似ている

## トレイトの定義: defining a trait

方の動作は、その型で呼び出すことができるメソッドで構成される

全ての型で同じメソッドを呼び出すことができる場合、 異なる型は同じ動作を共有する

トレイト定義は、メソッドシグネチャをグループ化し、
何らかの目的を達成するために必要な一連の動作を定義する方法である

```rust
pub trait Summary {
    fn summarize(&self) -> String;
}
```

トレイトの本文には複数のメソッドを含めることができる

## 型にトレイトを実装する: implementing a trait on a type

```rust
pub struct NewsArticle {
    pub headline: String,
    pub location: String,
    pub author: String,
    pub content: String,
}

impl Summary for NewsArticle {
    fn summarize(&self) -> String {
        format!("{}, by {} ({})", self.headline, self.author, self.location)
    }
}

pub struct Tweet {
    pub username: String,
    pub content: String,
    pub reply: bool,
    pub retweet: bool,
}

impl Summary for Tweet {
    fn summarize(&self) -> String {
        format!("{}: {}", self.username, self.content)
    }
}
```

型にトレイトを実装することは通常のメソッドを実装することに似ている

違いは、`impl`の後に実装するトレイト名を入れてから`for`キーワードを使用し、
トレイトを実装する型の名前を指定することである

`imple`ブロック内にトレイト定義が定義したメソッドシグネチャを配置する

```rust
let tweet = Tweet {
    username: String::from("horse_ebooks"),
    content: String::from("of course, as you probably already know, people"),
    reply: false,
    retweet: false,
};

println!("1 new tweet: {}", tweet.summarize());
```

この`Summary`と`NewsArticle`と`Tweet`は同じ`lib.rs`で定義していることに注意
(全て同じスコープにいる)

この`lib.rs`は`aggregator`と呼ばれるクレート(`cargo new aggregator`)であり、
他の誰かがクレートの機能を使用してライブラリのスコープ内で定義された構造体に
`Summary`トレイトを実装したいとする

その場合、最初にスコープにトレイトを入れる必要がある

`use aggregator::Summary;`を指定することで、`Summary`を実装できるようになる

(`use <PROJECT_NAME>::*`以外にも、 `mod lib;`,
`use crate::lib::*`で動作することを確認

ただし、推奨されないと思われる

これが動作する理由に関しては、`開発プロジェクト管理`のモジュールに関する記載を参照されたし)

クレイトの実装で注意すべき制限の１つは、
トレイトまたは型のいずれかがクレートに対してローカルである場合のみ、型に特性を実装できることである

例えば、`Tweet`型は`aggregator`のローカルであるため、
`aggregator`クレートの機能の一部として標準ライブラリのトレイト(`Display`など)
を実装できる

また、`Summary`トレイトは、`aggregator`に対してローカルであるため、
`Vec<T>`に`Summay`を実装することもできる

ただし、外部型に外部特性を実装することは出来ない

例えば、 `Display`トレイトと`Vec<T>`は標準ライブラリで実装されており、
`aggregator`に対してローカルでないため、
`Vec<T>`に対して`Display`トレイトを実装することは出来ない

この制限はコヒーレンス(coherence)と呼ばれるプログラムプロパティの一部であり、
より具体的には親の型が存在しないために名付けられた孤立ルールである

このルールは他人のコードがあなたのコードを破ることが出来ないことを保証する

このルールがない場合、２つのクレートは同じ型に対して同じトレイトを実装できるが、
Rustはどの実装を使用するかを知ることが出来ない

## デフォルト実装: default implementations

すべての型の全てのメソッドの実装を要求する代わりに、
トレイトの一部または全てのメソッドにデフォルトの動作を設定すると便利な場合がある

これは、特定の型にトレイトを実装するときに各メソッドのデフォルトの動作を維持
またはオーバーライドできる

```rust
pub trait Summary {
    fn summarize(&self) -> String {
        String::from("(Read more...)")
    }
}
```

カスタム実装を定義する代わりに、デフォルト実装を使用し、
`NewsArticle`のインスタンスに`summarize`を実装するには、
`impl Summary for NewsArticle {}`のように空の`impl`ブロックを指定する

デフォルト実装は、他のメソッドにデフォルト実装がない場合でも、
同じトレイトで他のメソッドを呼び出すことができる

```rust
pub trait Summary {
    fn summarize_author(&self) -> String;

    fn summarize(&self) -> String {
        format!("(Read more from {}...)", self.summarize_author())
    }
}
```

```rust
impl Summary for Tweet {
    fn summarize_author(&self) -> String {
        format!("@{}", self.username)
    }
}
```

```rust
let tweet = Tweet {
    username: String::from("horse_ebooks"),
    content: String::from("of course, as you probably already know, people"),
    reply: false,
    retweet: false,
};

println!("1 new tweet: {}", tweet.summarize());
```

同じメソッドのオーバーライド実装から
デフォルト実装を呼び出すことは出来ないことに注意

## 引数としてのトレイト: traits as parameters

トレイトを使用することで、 多くの異なる型を受け入れる関数を定義することができる

```rust
pub fn notify(item: impl Summary) {
    println!("Breaking news! {}", item.summarize());
}
```

型の代わりに、`impl`とトレイト名を渡している

`NewsArticle`または`Tweet`のインスタンスを渡すことができるが、
`String`や`i32`など、`Summary`を実装していない他の型を呼び出すコードは
コンパイルされない

## トレイトバインド構文: trait bound syntax

`impl Trait`構文は簡単な場合に機能するが、 実際には長い形式の糖衣構文であり、
これはトレイトバインドと呼ばれる

```rust
pub fn notify<T: Summary>(item: T) {
    println!("Breaking news! {}", item.summarize());
}
```

`impl Trait`構文は単純な場合により簡潔なコードになる

```rust
pub fn notify(item1: impl Summary, item2: impl Summary) {
```

もし、`item1`と`item2`に同じ型を強制したい場合、
トレイトバインドを使用して表現できる

```rust
pub fn notify<T: Summary>(item1: T, item2: T) {
```

## `+`構文を使用して、複数のトレイトバインドを指定する

複数のトレイトバインドを指定することができる

```rust
pub fn notify(item: impl Summary + Display) {
```

```rust
pub fn notify<T: Summary + Display>(item: T) {
```

## `where`句によるトレイトバインドの明確化

あまりにも多くのトレイトバインドを使用することには欠点がある
多くのトレイトバインド情報を含めることは、関数シグネチャを読みにくくする

```rust
fn some_function<T: Display + Clone, U: Clone + Debug>(t: T, u: U) -> i32 {
```

`where`句を使用することで、可読性を上げることができる

```rust
fn some_function<T, U>(t: T, u: U) -> i32
    where T: Display + Clone,
          U: Clone + Debug
{
```

## トレイトを実装する型を返す: returning types that implement traits

```rust
fn returns_summarizable() -> impl Summary {
    Tweet {
        username: String::from("horse_ebooks"),
        content: String::from("of course, as you probably already know, people"),
        reply: false,
        retweet: false,
    }
}
```

戻り値の型に`impl Summary`を使用することで、
`Summary`トレイトを実装する型を返すように指定する

この機能は、クロージャーとイテレーターのコンテキストで特に役立つ(?)

`impl Trait`は単一の方を返す場合のみに使用できる

次のようなコードは動かない

```rust
fn returns_summarizable(switch: bool) -> impl Summary {
    if switch {
        NewsArticle {
            headline: String::from("Penguins win the Stanley Cup Championship!"),
            location: String::from("Pittsburgh, PA, USA"),
            author: String::from("Iceburgh"),
            content: String::from("The Pittsburgh Penguins once again are the best
            hockey team in the NHL."),
        }
    } else {
        Tweet {
            username: String::from("horse_ebooks"),
            content: String::from("of course, as you probably already know, people"),
            reply: false,
            retweet: false,
        }
    }
}
```

## トレイトバインドで`largest`関数を修正する: fixing the largest function with trait bounds

`>`演算子は、標準ライブラリトレイト`std::cmp::PartialOrd`のデフォルトメソッドとして定義されているため、
`T`のトレイトバインドで`PartialOrd`を指定する必要がある

```rust
fn largest<T: PartialOrd>(list: &[T]) -> T {
```

また、`let mut largest = list[0]`を行うには、 コピートレイトの実装が必要である

```rust
fn largest<T: PartialOrd + Copy>(list: &[T]) -> T {
    let mut largest = list[0];

    for &item in list.iter() {
        if item > largest {
            largest = item;
        }
    }

    largest
}

fn main() {
    let number_list = vec![34, 50, 25, 100, 65];

    let result = largest(&number_list);
    println!("The largest number is {}", result);

    let char_list = vec!['y', 'm', 'a', 'q'];

    let result = largest(&char_list);
    println!("The largest char is {}", result);
}
```

`Copy`トレイトを実装する型に制限したくない場合は、
`Copy`ではなく`Clone`を指定する

ただし、`Clone`関数を使用すると、`String`などのヒープデータを所有する型の場合に
潜在的にヒープ割当が増え、大量のデータを処理している場合はヒープ割当が遅くなる可能性がある

もう一つの方法は、関数がスライスのT値への参照を返すことである

これにより、`Clone`または`Copy`トレイトを実装する必要がなくなり、
ヒープの割当を回避することもできる

## トレイトバインドを使用し、メソッドを条件付きで実装する: using trait bounds to conditionally implement methods

ジェネリック型パラメータを使用する`impl`ブロックでバインドされた
トレイトを使用することにより、指定されたトレイトを実装する型に対して
条件付きでメソッドを実装できる

```rust
use std::fmt::Display;

struct Pair<T> {
    x: T,
    y: T,
}

impl<T> Pair<T> {
    fn new(x: T, y: T) -> Self {
        Self {
            x,
            y,
        }
    }
}

impl<T: Display + PartialOrd> Pair<T> {
    fn cmp_display(&self) {
        if self.x >= self.y {
            println!("The largest member is x = {}", self.x);
        } else {
            println!("The largest member is y = {}", self.y);
        }
    }
}
```

別のトレイトを実装する、任意の型のトレイトを 条件付きで実装することもできる

トレイトバインドを満たす任意の方のトレイトの実装はブランケット実装と呼ばれ、
Rust標準ライブラリで広く使用されている

例えば、標準ライブラリは`Display`トレイトを実装する任意の型に
`ToString`トレイトを実装している

```rust
impl<T: Display> ToString for T {
    // --snip--
}
```

標準ライブラリにはこのブランケット実装があるため、
Displayトレイトを実装する任意の型の`ToString`トレイトによって定義された
`to_string`メソッドを呼び出すことができる

整数は、`Display`を実装しているため、 整数を対応する`String`に変換できる

```rust
let s = 3.to_string();
```

トレイトとトレイトバインドにより、ジェネリック型パラメーターを使用して、重複を減らすコードを記述できるが、
ジェネリック型に特定の動作をさせることをコンパイラに指定することもできる

コンパイラは、トレイとバインド情報を使用し、コードで使用される全ての具象型正しい動作を提供することを確認できる

動的に片付けされた言語では、メソッドを定義する型を実装していない型でメソッドを呼び出すと、
実行時にエラーが発生する

Rustはこれらのエラーをコンパイル時に出力するため、
こーどを実行する前に問題の修正を余儀なくされる

コンパイル時にすでにチェックしているため、
実行時に動作をチェックするコードを喜寿ルする必要はない

そうすることで、ジェネリックの柔軟性を放棄すること無く、
パフォーマンスが向上する
