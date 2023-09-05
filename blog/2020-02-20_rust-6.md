---
layout: layouts/blog.njk
title: "Rust覚書6: 開発プロジェクト管理"
tags:
  - blog
categories:
  - rust
---

## パッケージ、クレート、モジュールを使用した開発プロジェクトの管理: managing growing projects with packages, crates, and modules

大規模なプログラムを作成するときは、プログラム全体を追跡することが難しくなるため、
コードを整理することが重要になる

関連する機能をグループ化し、コードを個別の機能で分離することにより、
特定の機能を実装するコードの場所と、機能の動作を変更する場所を明確にする

パッケージには、複数のバイナリクレートと、オプションで1つのライブラリクレートを含めることができる

パッケージが大きく鳴門、パーツを個別のクレートに抽出して外部依存関係にできる

相互に関連する一連のパッケージが一緒に進化する非常に大きなプロジェクトの場合、
`Cargo`はワークスペースを提供する

グループ化機能に加えて、実装の詳細をカプセル化することで
より高いレベルでコードを再利用できる

コードの記述方法は、他のコードが使用するためにどの部分がパブリックであり、
どの部分が変更する権利を留保するプライベート実装の詳細であるかを定義する

Rustにはコードのまとまりを管理するための多くの機能があり、
どの機能が公開されるか、どの詳細がプライベートで、
どの名前がプログラムの各スコープにあるのか...

これらの機能はモージュルシステムと呼ばれることもかり、次の機能が含まれる
- Packages: クレートを構築、テスト、共有できる`Cargo`機能
- Crates: ライブラリ、または実行可能ファイルを生成するモジュールのツリー
- Modulesとuse: パスの集まり、スコープ、プライバシーの制御
- Paths: 構造体、関数、モジュールなどのアイテムに名前を付ける方法

## パッケージとクレート: packages and crates

クレートはバイナリまたはライブラリである

Rustコンパイラはクレートのルートモジュールから始まり、構築する

パッケージは一連の機能を提供する1つ以上のクレートである

パッケージにはこれらのクレートの構築方法を説明する`Cargo.toml`ファイルが含まれている

パッケージに含めることができるものは、いくつかのルールによって決まる

パッケージには、0または1つのライブラリクレートが含まれている必要がある

必要な数のバイナリクレートを含めることができるが、
少なくとも1つのクレート(ライブラリまたはバイナリ)を含める必要がある

`cargo new` コマンドを実行すると、
Cargoは`Cargo.toml`ファイルを作成し、パッケージを提供する

`Cargo.toml`を見てみると、Cargoは `src/main.rs`について記述していない

これはCargoは `src/main.rs`がパッケージと同じ名前のバイナリクレートのルートクレートであるという
規則に従っているためである

同様にパッケージディレクトリに `src/lib.rs`が含まれている場合、パッケージにはパッケージと同じ名前のライブラリクレートが含まれ、
`src/lib.rs`がそのクレートルートであると認識する

Cargoはクレートのルートファイルを`rustc`に渡し、ライブラリまたはバイナリをビルドする

パッケージに `src/main.rs`と`src/lib.rs`が含まれる場合、同じ名前のライブラリとバイナリの2つのクレートがあることになる

パッケージは、src/bin`ディレクトリにファイルを配置することにより、
複数のバイナリクレートを持つことができる

各ファイルは個別のバイナリクレートになる

クレートは関連する機能をスコープ内でグループ化するため、複数のプロジェクト間で機能を簡単に共有できる


クレートの機能を同時のスコープの保持することで、特定の機能がどのクレートで定義されているかが明確になり、潜在的な競合が

例えば、 `rand`クレートは`Rng`とういう名前の特性(`trait`)を提供する

仮に独自クレートで `Rng`という名前の構造体を定義下としても、名前空間が異なるため、
`Rng`という名前の意味についてコンパイラが混乱することはない

独自クレートでは、定義した`struct Rng`を指す

`rand`の~`Rng`にアクセスする場合は、`rand::Rng`と指定する

## スコープとプライバシーを制御するモジュールの定義: defining modules to control scope and privacy

モジュールを使用すると、クレート内のコードをグループに整理し、
可読性と簡単に再利用できるようになる

モジュールは、アイテムのプライバシーの制御できる
(public or private)

例として、 `cargo new --lib restaurant`を実行し、新しいライブラリを作成する

`src/lib.rs`

```rust
mod front_of_house {
    mod hosting {
        fn add_to_waitlist() {}

        fn seat_at_table() {}
    }

    mod serving {
        fn take_order() {}

        fn serve_order() {}

        fn take_payment() {}
    }
}
```

`mod`キーワードでモジュールを定義し、次にモジュールの名前を指定している

モジュール内部には、他のモジュールを使用することもできる

モジュールは、構造体、列挙、定数、特性、関数などの他のアイテムの定義も保持できる

モジュールを使用することにより、関連する定義をグループかし、関連する理由を指定できる

このコードを使用するプログラマーは、全ての定義を読む必要が無く、グループに基づいてコードを探すことができるため、
使用したい定義を見つけるのが簡単になる

モジュールツリー全体がクレートという名前の暗黙的なモジュールの下にあることに注意

モジュールツリーは、コンピューター上のファイルシステムのディレクトリツリーに似ている

ファイルシステムのディレクトリと同様に、モジュールを使用してコードを整理できる

また、ディレクトリ無いのファイルと同様に、モジュールを見つける方法が必要である

## モジュールツリー内のアイテムを参照するためのパス: paths for referring to an item in the module tree
関数を呼び出したい場合、そのパスを知る必要がある

モジュールツリーないのアイテムの場所をRustに示すために、ファイルシステムのパスを使用するのと同じ方法でパスを使用する

パスには2つの形式がある
- 絶対パスは、クレート名またはリテラルクレートを使用してクレートルートから始まる
- 総チアパスは、現在のモジュールから始まり、
現在のモジュールの`self`, `super`,または識別子を使用する

相対パスと絶対パスの両方とも二重コロン(`::`)で区切られた1つ以上の識別子が続く

```rust
mod front_of_house {
    mod hosting {
        fn add_to_waitlist() {}
    }
}

pub fn eat_at_restaurant() {
    // Absolute path
    crate::front_of_house::hosting::add_to_waitlist();

    // Relative path
    front_of_house::hosting::add_to_waitlist();
}
```

この例ではクレートルートで定義された関数(`eat_at_restaurant`)から
`add_to_waitlist`関数を呼び出す2つの方法を示している

`eat_at_restaurant`関数はライブラリクレートのパブリックAPIの一部であるため、 `pub`キーワードでマークしている

1回目は、絶対パスを使って呼び出している

`add_to_waitlist`関数は`eat_at_restaurant`と同じクレートで定義されているため、`crate`から始まる絶対パスを使用している

2回目は、相対パスを使って呼び出している

パスは、`eat_at_restaurant`と同じモジュールツリーのレベルで定義されたモジュールの名前である`front_of_house`から始まる

相対パスを使用するか、絶対パスを使用するかは、プロジェクトに基づいて決定する

決定基準は、アイテムを使用するコードとは別にアイテム定義コードを移動するか一緒に移動する可能性が高いかによって異なる

例えば、`front_of_house`モジュールと`eat_at_restaurant`を`customer_experience`というモジュールに移動した場合、
絶対パスを`add_to_waitlist`に更新する必要があるが、相対パスは引き続き有効である

しかし、`eat_at_restaurant`関数を`ining`という名前のモジュールに個別に移動した場合、`add_to_waitlist`呼び出しへの絶対パスは変わらないが、
相対パスを更新する必要がある

コード定義とアイテム呼び出しを互いに独立して移動する可能性が高い場合、絶対パスを指定することをおすすめする

しかし、上記のコードはコンパイルで失敗する

なぜなら、`hosting`がプライベートであるため

モジュールはコードを整理するだけに役立つわけではない　　
モジュールは、Rustのプライバシー境界も定義する

外部コードの実装の詳細をカプセル化することは認識、呼び出し、または依存を許可しない

したがって、関数や構造体のようなアイテムをプライベートにしたい場合は、モジュールに入れる

Rsutはデフォルトで全てのアイテムがデフォルトでプライベートである

親モジュールのアイテムは子モジュール内のプライベートアイテムを使用出来ないが、子モジュールは先祖のモジュールアイテムを使用できる

理由は、子モジュールは実装の詳細をラップして非表示にしているが、子モジュールは定義されているコンテキストを見ることができるからである

Rustはモジュールシステムをこのように機能させることを選択したため、内部実装の詳細を非表示にすることがデフォルトである

そうすることで内部コードのどの部分を外部コードを破壊せずに変更できるかわかる

## `pub`キーワードでパスを公開する: exposing paths with the pub keyword

```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

pub fn eat_at_restaurant() {
    // Absolute path
    crate::front_of_house::hosting::add_to_waitlist();

    // Relative path
    front_of_house::hosting::add_to_waitlist();
}
```

## `super`を使用した相対パスの開始
パスの先頭で`super`を使用して、親モジュールで始まる相対パスを構築することもできる

これは、 `..`構文でファイルシステムを開始するようなものである

```rust
fn serve_order() {}

mod back_of_house {
    fn fix_incorrect_order() {
        cook_order();
        super::serve_order();
    }

    fn cook_order() {}
}
```

## 構造体と列挙型を公開する: making structs and enums public
`pub` を使用して、構造体と列挙型をパブリックとして指定できるがいくつかの追加事項がある

構造体定義の前に`pub`を使用する場合、構造体はパブリックだが、フィールドはプライベートである

フィールド毎にパブリックを設定する必要がある

```rust
mod back_of_house {
    pub struct Breakfast {
        pub toast: String,
        seasonal_fruit: String,
    }

    impl Breakfast {
        pub fn summer(toast: &str) -> Breakfast {
            Breakfast {
                toast: String::from(toast),
                seasonal_fruit: String::from("peaches"),
            }
        }
    }
}

pub fn eat_at_restaurant() {
    // Order a breakfast in the summer with Rye toast
    let mut meal = back_of_house::Breakfast::summer("Rye");
    // Change our mind about what bread we'd like
    meal.toast = String::from("Wheat");
    println!("I'd like {} toast please", meal.toast);

    // The next line won't compile if we uncomment it; we're not allowed
    // to see or modify the seasonal fruit that comes with the meal
    // meal.seasonal_fruit = String::from("blueberries");
}
```

`eat_at_restaurant`は、
Breakfast`の`toast`フィールドにアクセスはできるが
`seasonal_fruit`フィールドにはアクセスできない

対象的に、`enum`をパブリックにすると、その`variant`は全てパブリックになる

```rust
mod back_of_house {
    pub enum Appetizer {
        Soup,
        Salad,
    }
}

pub fn eat_at_restaurant() {
    let order1 = back_of_house::Appetizer::Soup;
    let order2 = back_of_house::Appetizer::Salad;
}
```

`enum`は`variant`が`public`でないと非常に使いにくく、全ての `variant`に`pub`を付ける必要があるため、
デフォルトはパブリックになる

構造体はフィールドがパブリックでなくても有用な場合が多いため、
デフォルトがプライベートという一般的な規則に従う

## `use`キーワードを使用してパスをスコープに入れる: bringing paths into scope with the use keyword
`add_to_waitlist`関数を呼び出すたびに`front_of_house`と`hosting`も指定する必要があったが、
`use`キーワードを使ってパスを一度スコープに入れることで、
ローカルアイテムのようにアイテムのパスを呼び出せるようになる

```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}
```

スコープに`use`とパスを追加することはファイルシステムにシンボリックリンクを作成するのと似ている

クレートルートに`use crate::front_of_house::hosting`を追加すると、
`hosting`はそのスコープ内で有効な名前になる

(まるで、`hosting`モジュールがクレートルートで定義されているかのように)

`use`を使ってパスをスコープに入れた場合でも他のパス同様にプライバシーチェックがされる

`use`と相対パスを使っても、
パスをスコープ内に入れることができる

```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

use front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}
```

## 慣用的な`use`パスの作成

なぜ、下記のように`add_to_waitlist`までパスを通さず、
`hosting::add_to_waitlist`とするのか

```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

use crate::front_of_house::hosting::add_to_waitlist;

pub fn eat_at_restaurant() {
    add_to_waitlist();
    add_to_waitlist();
    add_to_waitlist();
}
```

実行内用は変わらないが、 `use crate::front_of_house::hosting::add_to_waitlist`よりも
`use crate::front_of_house::hosting`の方がスコープに入れる慣用的な方法である

これは、関数を呼び出すときに
親モジュールを指定する必要必要がある方が関数がローカルで定義されていないことが明らかになるからである

上記は`add_to_waitlist`がどこで定義されているかが明確ではない

一方で、構造体、列挙型、及びその他のアイテムを使う場合は、フルパスを指定するのが常識である

```rust
use std::collections::HashMap;

fn main() {
    let mut map = HashMap::new();
    map.insert(1, 2);
}
```

この慣習には明確な理由になる背景は存在しないが、
Rustを書いてきた人々は習慣的にこのようにコードを書いてきた

ただし、この慣習は`use`ステートメントを使用して同じ名前の2つのアイテムをスコープに入れる場合は例外である

このような場合にはRustがそれを許可しない

```rust
use std::fmt;
use std::io;

fn function1() -> fmt::Result {
    // --snip--
}

fn function2() -> io::Result<()> {
    // --snip--
}
```

見ての通り、親モジュールを使用すると2つの`Result`が区別されている

## `as`キーワードで新しい名前を提供する: providing new names with the `as` keyword
同じ名前の2つの型を使用して同じスコープに入れる問題に対する別の解決サクがある

パスの後に、`as`と新しいローカル名またはエイリアスを型として指定できる

```rust

use std::fmt::Result;
use std::io::Result as IoResult;

fn function1() -> Result {
    // --snip--
}

fn function2() -> IoResult<()> {
    // --snip--
}
```

これにより、
`std::fmt::Result`と`std::io::Result`は競合しない

## `pub use`そ使用した名前の再エクスポート: re-exporting names with `pub use`
`use`キワードで、名前をスコープに入れた時、
新しいスコープで使用可能なプライベートになる

コードを呼び出すコードがその名前をそのコードのスコープで定義されているかのように
参照できるようにするには `pub`と`use`を組み合わせることができる

この手法は再エクスポート(re-exporting)とよばれる

これは、アイテムをスコープ内に入れるだけでなく、
そのアイテムを外部からもスコープに入れることができるようにするためである

```rust
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
    }
}

pub use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}
```
`pub use`を使用することによって、外部コードも`hosting::add_to_waitlist`を使用して
`add_to_waitlist`関数を呼び出せるようになる

再エクスポートは、コードの内部構造が異なる場合に
コードを呼び出すプログラマーがドメインについて考えるときに使いやすい

## 外部パッケージの使用: using external packages
`rand`と呼ばれる外部パッケージを使用する時、
`Cargo.toml`に次の行を追加する

```rust
[dependencies]
rand = "0.5.5"
```

`Cargo.toml`で依存関係として`rand`を追加すると、
Cargoは`rand`パッケージと依存関係を crgo.io からダウンロードし、
`rund`をプロジェクトで使用できるようにする

`rand`定義をパッケージのスコープに取り込むために、
`uaw`行を追加してスコープに取り込みたいアイテムをリストした（直訳）

```rust
use rand::Rng;
fn main() {
    let secret_number = rand::thread_rng().gen_range(1, 101);
}
```

Rustコミュニティーのメンバーは多くのパッケージを`crates.io`で使えるようにしており、
そのいずれかのパッケージを取り込むには、
パッケージの`Cargo.toml`ファイルにそれらを記載し、`use`を使ってアイテムをスコープに入れる

標準ライブラリ(`std`)もパッケージの外部にあるクレートである

標準ライブラリはRust言語が付属しているため、
Cargo.tomlを変更して`std`を含める必要がない

ただし、それらを参照するには `use`を使用してアイテムをスコープに入れる必要がある

```rust
use std::collections::HashMap;
```

これは標準ライブラリクレートの名前である`std`で始まる絶対パスである

## ネストされたパスをつ合って大規模な`use`リストをクリーンアップする: using nested paths to clean up large use lists

野菜じパッケージまたら同じモジュールで定義された複数のアイテムを使用している場合、
それらを並べると垂直方向に多くのスペースを専有する可能性がある

```rust
use std::io;
use std::cmp::Ordering;
```

これの代わりに、ネストされたパスを使用して、同じアイテムを1行でスコープに入れることができる

```rust
use std::{cmp::Ordering, io};
```

大きなプログラム内で、多くのアイテムを同じバッケージやモジュールからスコープに入れるが、
ネストされたパスを使用すると、多くの`use`ステートメントを減らすことができる

```rust
use std::io;
use std::io::Write;
```

```rust
use std::io::{self, Write};
```

## グローブ演算子: the glob operator

パスで定義された全てのパブリックアイテムをスコープに居れたい場合、
パスの後に `*`が続くグローブ演算子を指定できる

```rust
use std::collections::*;
```

この`use`ステートメントは`std::collections`で定義されている全てのパブリックアイテムを現在のスコープに取り込む

グローブ演算子を使う場合は注意する必要がある
（`glob`を使うとスコープ内の名前とプログラムで使用される名前が定義された場所を区別しにくくなる）

グローブ演算子は、よくテストで全ての対象をテストモジュールに入れるのに使用される

## モジュールを異なるファイルに分離する
モジュールが大きくなった場合、コードの追跡をしやすくするために定義を別のファイルに移すことをおすすめする

`src/lib.rs`

```rust
mod front_of_house;

pub use crate::front_of_house::hosting;

pub fn eat_at_restaurant() {
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
    hosting::add_to_waitlist();
}
```

`src/front_of_house.rs`

```rust
pub mod hosting {
    pub fn add_to_waitlist() {}
}
```

ブロックを使用せず、`mod front_of_house`の後にセミコロンを使用すると、
モジュールと同じ名前の別のファイルからモジュールの内容をロードするように指示する
モジュールツリーは同じままで、定義が異なるファイルに存在する場合でも、変更無しで機能する

この手法により、モジュールのサイズが大きくなるにつれて、
モジュールを新しいファイルに移動できる

## 要約: summary
Rustではパッケージを複数のクレートに分割し、クレートをモジュールに分割できるため、あるモジュールで定義されたアイテムを別のモジュールから参照できる

モジュールはデフォルトではプライベートだが、`pub`キーワードを追加することで定義をパブリックにできる

## 参考
- [The Rust Programming Language: Managing Growing Projects with Packages, Crate, and Modules](https://doc.rust-lang.org/book/ch07-00-managing-growing-projects-with-packages-crates-and-modules.html)
