---
layout: layouts/blog.njk
title: "Rust覚書4: 構造体(Structs)"
tags:
  - blog
categories:
  - rust
---

## 構造体を使った関連データの構造化: using structs to structure related data

構造体または構造化はカスタムデータ型で、
複数の関連する値に名前を付けてパッケージ化し、 意味のあるグループを作成できる

## 構造体の定義のインスタンス化: defining and instantiating structs

構造体はタプルのように異なる型で構成できる

タプルと異なり、各データに名前を付けて値の意味を明確にできるため、
インスタンスの値にアクセスするときにデータの順序を気にする必要がなくなる

```rust
struct User {
    username: String,
    email: String,
    sign_in_count: u64,
    active: bool
}
```

```rust
let user1 = User {
    email: String::from("someone@example.com"),
    username: String::from("someusername"),
    active: true,
    sign_in_count: 1,
};
```

インスタンスが可変な場合、 特定のフィールドに割り当てることで値を変更できる

この時、インスタンス全体が可変で有ることに注意

```rust
let mut user1 = User {
    email: String::from("someone@example.com"),
    username: String::from("someusername"),
    active: true,
    sign_in_count: 1,
};

user1.email = String::from("anotheremail@example.com");
```

Rustでは特定のフィールドを可変にすることは出来ない

```rust
fn build_user(email: String, username: String) -> User {
    User {
        email: email,
        username: username,
        active: true,
        sign_in_count: 1,
    }
}
```

関数の引数に構造体と同じ名前を付けることは理にかなって入るが、同じフィールド名と変数名を繰り返すのは面倒

### 変数とフィールドに同じ名前を利用する場合のフィールド初期化の短縮

```rust
fn build_user(email: String, username: String) -> User {
    User {
        email,
        username,
        active: true,
        sign_in_count: 1,
    }
}
```

## 構造体更新構文を利用した他のインスタンスからインスタンスの生成

古いインスタンスの値をほとんど使用し、一部だけ更新したい場合がある

更新構文を使わない場合の例を示す

```rust
let user2 = User {
    email: String::from("another@example.com"),
    username: String::from("anotherusername567"),
    active: user1.active,
    sign_in_count: user1.sign_in_count,
};
```

次に更新構文を使った例を示す

```rust
let user2 = User {
    email: String::from("another@example.com"),
    username: String::from("anotherusername567"),
    ..user1
};
```

`..`構文は、明示的に指定されていない残りのフィールドが指定されたインスタンスのフィールドと同じ値を持つように指定する

## 名前付きフィールドのないタプル構造を使用した構造体定義の作成

タプル構造体と呼ばれる、タプルに似た構造体を定義することもできる

```rust
struct Color(i32, i32, i32);
struct Point(i32, i32, i32);

let black = Color(0, 0, 0);
let origin = Point(0, 0, 0);
```

この時、変数 `black`と `origin`は異なる型である

## フィールドのないUnit-Like構造体

フィールドを持たない構造体を定義することもできる

これらはユニット型(`()`)と同様に動作するため、`unit-like`と呼ばれる

unit-like構造体は、ある方に特性を実装する必要があるが、その型自体に保存したいデータがない場合に役立つ

`Go`でもあるよね、空の構造体

## 構造体データの所有権: ownership of struct data

```rust
struct User {
    username: String,
    email: String,
    sign_in_count: u64,
    active: bool
}
```

この例では、文字列スライス `&str`ではなく、文字列 `String`を使用している

これはこの構造体のインスタンスが全てのデータを所有し、
そのデータが構造体全体が有効である限り有効であるための意図的な選択である(?)

構造体は、他が所有するデータへの参照を保存することもできるが、
保存するには有効期間(`lifetimes`)を使用する必要がある

有効期間は、構造体が参照しているデータが構造体が有効である限り有効である個を保証する

次のように、有効期間を指定せずに構造体に参照を保存しようとすると、
コンパイルを通らなくなる

```rust
struct User {
    username: &str,
    email: &str,
    sign_in_count: u64,
    active: bool,
}

fn main() {
    let user1 = User {
        email: "someone@example.com",
        username: "someusername123",
        active: true,
        sign_in_count: 1,
    };
}
```

※ ここでは、有効期間に関する説明はしない

## 構造体を利用したプログラム例

構造体を使用するタイミングを理解するための例を示す

```rust
fn main() {
    let width1 = 30;
    let height1 = 50;

    println!(
        "The area of the rectangle is {} square pixels.",
        area(width1, height1)
    );
}

fn area(width: u32, height: u32) -> u32 {
    width * height
}
```

このプログラムの修正していく

まず、幅と高さを互いに関連していることに注目

しかしながら、プログラム上では関連することを示すものがない

幅と高さをグループ化することで読みやすく、管理しやすくなる

### タプルを使用したリファクタリング: refactoring with tuples

```rust
fn main() {
    let rect1 = (30, 50);

    println!(
        "The area of the rectangle is {} square pixels.",
        area(rect1)
    );
}

fn area(dimensions: (u32, u32)) -> u32 {
    dimensions.0 * dimensions.1
}
```

値がグループ化されたことでよりわかりやすくなり、引数を1つ渡すだけで済む

しかし、タプルは要素に名前を付けることが出来ないため、
`area`関数側の計算を複雑にしてしまっている (添字で0,
1と言われても幅なのか高さなのかを推測出来ないため)

これらはエラーを引き起こす要因になり得る

### 構造体を使用したリファクタリング（意味の付加）: refactoring with structs(adding more meaning)

構造体を利用することでデータにラベルを付けて意味を付加する

```rust
struct Rectangle {
    width: u32,
    height: u32,
}

fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };

    println!(
        "The area of the rectangle is {} square pixels.",
        area(&rect1)
    );
}

fn area(rectangle: &Rectangle) -> u32 {
    rectangle.width * rectangle.height
}
```

ここでは、 `Rectangle`という構造体を定義している

`area`関数は所有権を受け取らず借りているだけなので、
`main`関数は所有権を保持し、 `rect1`の使用を継続できる

これが関数を呼び出すときに参照 `&`を使用するべきタイミングである

これによって、 `area`関数は `width` と `height`にアクセスできるだけでなく、
それぞれの値が何を意味しているかを知ることができる

## 派生特性による有用な機能の追加: adding useful functionality with derived traits

プログラムのデバッグ中に構造体の印刷を出力し、その全てのフィールドの値を確認できると便利である
マクロ `println!`は標準的な型(primitive
types)しかサポートしておらず、構造体の出力は機能しない

次の例はコンパイルエラーとなる

```rust
struct Rectangle {
    width: u32,
    height: u32,
}

fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };

    println!("rect1 is {}", rect1);
}
```

Rustでは構造体の表示は実装されていない

しかしながら、デバッグ特性を使用すると、
開発者にとって便利な方法で構造体を出力することができる

Rustにはデバッグ情報を出力する機能があるが、
構造体でその機能を使用できるように明示的に注釈(`annotation`)を付ける必要がある

次のように、構造体の直前に `#[derive(Debug)]`を付ける

```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };

    println!("rect1 is {:?}", rect1);
}
```

Rustではカスタム型に便利な動作を追加できるアノテーションをいくつか用意している

## メソッド構文: method syntax

メソッドは構造体(、列挙型(`enum`)、特性(`trait`)オブジェクト)のコンテキスト内で定義されるという点で、
関数とは異なる

また、最初の引数は常に`self`であり、メソッドが呼び出される構造体のインスタンスを表す

## メソッドの定義: defining methods

構造体のコンテキスト内にメソッドを定義するには、
`impl`(implementation)ブロックを作成し、その中に関数を作る

```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
}

fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };

    println!(
        "The area of the rectangle is {} square pixels.",
        rect1.area()
    );
}
```

この時、 `self`の前に `&`を使用する必要があることに注意

メソッドは、他の引数と同様に
`self`の所有権を取得したり、可変借用、不変借用することができる

`area`は、
`所有権を取得したいのではなく、単に読み取りを行いたいだけなので、不変借用を行っている

メソッドの機能の一部としてメソッドを呼び出したインスタンスを変更する場合は、
最初の引数として `&mut self`を使用する

最初の引数として、
`self`のみを使用してインスタンスの所有権を取得するメソッドを持つことは稀である
この手法は通常、メソッドが自分自身を別のものに変換し、
変換後に呼び出し元が元のインスタンスを使用しないようにする場合に使用される

関数の代わりにメソッドを使用する主な利点は、
`self`を使うことで型の指定を繰り返す必要が無いことであり、
これは組織(?)のためでもある

コードの将来のユーザーが、
提供するライブラリーの様々な場所で構造体の機能を検索するよりも、
型のインスタンスでできることを全て1つの
`impl`ブロック入れてしまうほうが理にかなっている

## `->`演算子はどこへ？: Where's the `->` Operator?

C, C++ではメソッドの呼び出しに2つの異なる演算子が使用される

オブジェクトのメソッドを直接呼び出す場合は `.`を使用し、
オブジェクトへのポインターでメソッドを呼び出しており、最初にポインターを逆参照する必要がある場合は
`->`を使用する

言い換えるならば、オブジェクトがポインターの場合、 `object->something()`と
`(*object).something()`は似ている

Rustには `->`演算子に該当するものは存在しない

代わりに、自動参照及び逆参照と呼ばれる機能が存在する

メソッドの呼び出しはこの動作を持つRustの数少ない場所の1つ

`object.something()`を呼び出した時、 Rustは自動的に `&`, `&mut`または
`*`を追加してオブジェクトがメソッドのシグネチャーと一致するようにする
つまり、次のことは同じである

```rust
p1.destance(&p2);
(&p1).distance(&p2);
```

1つめの方がとても綺麗に見える

この自動参照動作は、メソッドに明確なレシーバー(`self`型)があるため機能する

メソッドのレシーバーと名前が与えられると、
Rustはメソッドが読み取り(`&self`)、変更(`&mut self`)、または消費(`self`)のいずれであるかを明確に把握できる

Rustがメソッドレシーバーに暗黙的に借用するという事実は、
実際に所有権を人間工学に基づいたものにするための大きな部分

## より多くの引数をもつメソッド: methods with more parameters

メソッドは引数`self`の後に複数の複数の引数を取ることができ、関数の引数のように機能する

```rust
impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }

    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
}
```

```rust
fn main() {
    let rect1 = Rectangle { width: 30, height: 50 };
    let rect2 = Rectangle { width: 10, height: 40 };
    let rect3 = Rectangle { width: 60, height: 45 };

    println!("Can rect1 hold rect2? {}", rect1.can_hold(&rect2));
    println!("Can rect1 hold rect3? {}", rect1.can_hold(&rect3));
}
```

## 関連機能: associated functions

`impl`ブロックのほかの便利な機能として、 `self`を受け取らない
`impl`ブロック内の関数を定義できることがある

これらは、構造体に関連付けられているため、関連関数(associated
functions)と呼ばれる

これらは、メソッドではなく、まだ、関数である

なぜなら動作するための構造体インスタンスを必要都市無いからである

すでに `String::from`関連関数を使用している

関連関数は、構造体の新しいインスタンスを返すコンストラクタとしてよく使用される

```rust
impl Rectangle {
    fn square(size: u32) -> Rectangle {
        Rectangle { width: size, height: size }
    }
}
```

この関連関数を呼び出すには、構造体名と `::`構文を使用する

`let sq = Rectangle::square(3);`のように

この関数は、構造体によって名前空間が付けられている

`::`構文は、モジュールによって作成された関連関数と名前空間(namespace)の両方に使用される

## 複数の`impl`ブロック: multiple impl blocks

各構造体には、複数の`impl`ブロックを含めることができる

```rust
impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }
}

impl Rectangle {
    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width > other.width && self.height > other.height
    }
}
```

ここでこれらのメソッドを複数の
`impl`ブロックに分ける理由は無いが、これは有効な構文である

## 要約: summary

構造体を使用すると、領域(`domain`)にとって意味のあるカスタム型を作成できる

構造体を使用することで、関連データの断片を互いに結びつけたままに、各断片に名前を付けてコードを明確にすることができる

メソッドを使用すると、構造体のインスタンスが持つ動作を指定できる

関連関数を使用すると、インスタンスを使用せずに構造体に固有の名前空間機能を使用できる

ただし、カスタム型を作成できるのは構造体だけではない

## 個人的な感想

構造体に関数を実装することで、他の言語で言うところの`class`に該当する機能を実装しているのだなー

構造体の要素をフィールド、関数をメソッドと呼ぶあたりが
`class`を意識しているのだと感じる

この辺はGoとも似てるかな

## 参考

- [The Rust Programming Language: 5. Using Structs to Structure Related Data](https://doc.rust-lang.org/book/ch05-00-structs.html)
