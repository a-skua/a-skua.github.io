---
layout: layouts/blog.njk
title: "Rust覚書3: 所有権(Ownership)"
tags:
  - blog
categories:
  - rust
---

## 所有権: ownership

Rustの最も特徴的な機能であり、
ガベージコレクタ(`garbage collector`)を必要とせずにメモリ安全を保証するもの

つまり、めちゃくちゃ大事なことである

いくつかの言語はGC(ガベージコレクタ)が絶えず動いており、
それ以外の言語はプログラマが明示的にメモリ解放を行う必要がある

Rustは第3のアプローチを行う: メモリは所有権によってコンパイル時に管理される

また、所有権はプログラムの実行速度に影響しない

多くのプログラマにとって所有権は新しいコンセプトである

おそらくココが一番の難関と思われる

### スタックとヒープ: the stack and the heap

多くの言語ではスタックとヒープを意識することはないが、
Rustのような言語では値がスタックであるかヒープであるかは処理において大きく影響する

スタックに格納する値はサイズが判明している必要があり、
コンパイル時のサイズが不明または変更される可能性がある場合はヒープに格納される必要がある

スタックはLIFOであり、一番下や真ん中と行った値の削除を行うことが出来ない

ヒープはデータの格納依頼を出した時、 OSが空き領域を確保し、先頭のポインタを返す

このプロセスをヒープの割当という

stackへ値をpushすることは割当とはみなされていない
(スタックへ格納するデータサイズは既知であるため)

OSがデータの格納領域を割り当てる必要がないため、
stackにpushするほうがheapに割当(allocation)するよりも速いのは明白である

データアクセスに関してもheapはstackよりも遅くなる
(stackのpointerは常に一番上にあるが、heapのポインタはたどる必要があるため...
現在のOSはmemory jumpが少ないほど高速である)

heapに大容量の割当を行う場合も時間がかかる場合がある

関数を呼び出す時、関数に渡された値及びローカル変数がstackにpushされる

関数が終了する時、これらの値はstackからpopされる

コードのどの部分がヒープ上のどのデータを使用しているかを追跡し、
ヒープ上のデータの重複の排除、
ヒープ上の未使用データを排除してスペースが不足しないようにすることは全ての所有者が対処するべき問題である

所有権について理解することができれば、
stackとheapについて頻繁に考える必要がなくなる

(これが所有権の存在する理由である)

## 所有権の規則: ownership rules

- Rustの各値には所有者と呼ばれる変数がある
- 所有者は一度に一人のみ
- 所有者が範囲外になると、値は削除される

## 変数スコープ

変数スコープは波括弧内にて有効

```rust
{
    let s = "hello";
}
```

- `s`はスコープに入ると(宣言された場所から)有効になる
- 範囲外になるまで(波括弧の末尾まで)有効

このあたりは他の言語と同じ

### 文字列型

標準データ型はstackにpushされる

ここではheapに格納されているデータを見て、 Rustがそのデータを何時clean
upするかを調べるために 文字列型を例に使用

Rustには2つの `String`が存在する

```rust
// first string
let s = "string";

// second string
let s = String::new();

let mut s = String::from("hello");
s.push_str(", world!");
```

- 1つ目の `String`は `immutable`(不変)である(String literal)
- 2つ目は、 heapに割り当てられるため、compile時に不明な量のテキストを格納できる
  (ということは1つ目はstack?)

`double colon`(::)は `name space`(名前空間)を許可する演算子

## メモリと割り当て: memory and allocation

文字列リテラル(`String literal`)はコンパイル時に値がわかるため、
直接ハードコーディングされる

故に高速ではあるが、不変になる

文字列型を可変にするには、heapにメモリを割り当てる必要がある

コンパイル時には不明であるため、次のことを意味する

- 実行時にOSにメモリ要求をする必要がある
- Stringの処理が完了後、メモリをOSに返す方法が必要

1つ目については、実際に `String::form`は実装に必要なメモリを要求している

2つ目については、GCを利用している言語とは異なる

(略)

Rustでは、メモリを所有する変数がスコープから外れると、メモリは自動的に返される

```rust
{
    let s = String::form("hello");
}
```

上記の例ではメモリを返すべき適切なタイミングが存在する

`s` が範囲外になった時... 変数が範囲外になるとRustは特別な関数を呼び出す
(このコードは `drop`と呼ばれる)

Rustは中括弧を閉じるときに自動的に `drop`を実行する

### 重要

この特性はコードの記述方法に大きな影響を及ぼす

現時点では簡単に見えるかもしれないが、heapに割り当てたデータを複数の変数に使用させたい場合、
より複雑の状況において予期しないものになる可能性がある

## 変数とデータの相互作用: move

Rustでは、複数の変数が異なる方法で同じデータと対話できる

```rust
let x = 5;
let y = x;
```

`x` は `5` であり、 `y`は `x`をコピーしている

整数のサイズは既知であるため、 これらの2つの値は stackにpushされている

```rust
let s1 = String::from("hello");
let s2 = s1;
```

しかし、この場合はうまくは行かない

`s1` の情報(lengthやcapacity)はstackにあるが、
コンテンツ(実際の文字列)はheap上にある

そのため、`s2` には `s1` の情報はコピーされ、stackに格納されるが、
コンテンツ自体はコピーされず、 `s1` と `s2` は同じ内容を指すことになる

説明難しいので
[ここ](https://doc.rust-lang.org/book/ch04-01-what-is-ownership.html#ways-variables-and-data-interact-move)
の図を見て

### 再掲

```rust
let s1 = String::from("hello");
let s2 = s1;
```

Rustでは、`s1` を `s2` に代入すると、 `s1`を無効とみなす

そのため、この直後に `s1` にを利用しようとすると、compile errorとなる

Rustでは無効化された参照を使用出来ない

他の言語において、 `shallow copy`と、 `deep copy`という表現がある

(前者はpointerのコピーのことかな？※ おそらくheapのコピーのことかな)

Rustは最初の変数(ココで言う `s1`)を無効化するため、
`shallow copy`ではなく`move`と呼ばれる

Rustは自動的に `deep copy`を行わないため、
実行時のパフォーマンスの観点からは安価であると想定できる

## 変数とデータの相互作用: clone

文字列のヒープデータを `deap copy`ををする場合、
`clone`と呼ばれる一般的なメソッドを使用する

```rust
let s1 = String::from("hello");
let s2 = s1.clone();
```

ただし、これはパフォーマンスの観点から言うと高価である

## stackのみのデータ: copy

```rust
let x = 5;
let y = x;
```

Stringの場合と異なり、この場合は `x`も `y`も有効である

コンパイル時に既知のサイズを持つ型は完全にstackに格納されるため、
コピーをすばやく作成できるからである

これは `y`を作成した後に `x`を無効にする理由にはならない

`clone`を呼び出したとしても、結果は変わらない

```rust
let x = 5;
let y = x.clone(); // same let y = x;
```

Rustには `copy`特性と呼ばれる特別な注釈がある

型に `copy`特性がある場合、古い変数は割当後も引き続き使用できる

Rustでは型またはその一部が `drop`特性を実装している場合、
`copy`特性を注釈として付けることは出来ない

値が範囲外になったときに肩に特別なことが必要な場合、 その型に
`copy`特性を付けると compile error になる

一般的なルールとして単純な
`scalar`値(integerなどのstackを利用する値？)のグループは 全て
`copy`でき、メモリ割り当てが必要なりソースなどは `copy`出来ない

### copyできる基本的な型

- 全ての整数
- 真偽
- 全ての浮動点少数
- 文字
- copy可能な値のみで構成される `tuple`

## 所有権と関数: ownership and functions

関数に値を渡すための `semantics`は変数に値を割り当てるための
`semantics`と似ている (semantics?)

関数に値を渡すと、 `move`または `copy`が行われる

```rust
let s = String::from("hello");

foo(s); // move

println!("{}", s); // compile error
```

```rust
let x = 5;

foo(x); // copy

println!("{}", x); // ok
```

これらの静的チェックはミスを防ぐためにある

## 戻り値と範囲: return values and scope

値を返すことで、所有権を譲渡することもできる

```rust
fn main() {
    let s1 = foo();

    let s2 = String::from("hello");

    let s3 = bar(s2); // move

    println!("{}, {}", s1, s3); // ok

    println!("{}", s2); // compile error
}

fn foo() -> String {
    String::from("hello") // move
}

fn bar(mut s: String) -> {
    s.push_str(", world");

    s // move
}
```

変数の所有権は毎回同じパターンに従う

値を別の変数に割り当てると、値が移動(move)する

heap上のデータを含む変数が範囲外になった場合、 所有権が移動していない場合は
`drop`される

戻り値に`tuple`を使うことも可能

```rust
fn main() {
    let (s, len) = foo();
    println!("{}, {}", s, len);
}

fn foo() -> (String, usize) {
    let s = String::from("hello");
    let len = s.len();

    (s, len)
}
```

しかし、全ての関数で所有権を取得し戻すのは面倒である

そこで、Rustには参照と呼ばれる機能がある

## 参照と借用: references and borrowing

参照を使うと、関数へ変数の所有権を譲渡せずに、参照値を渡すことができる

```rust
fn main() {
    let s = String::from("foo bar");

    let len = foo(&s); // reference; not move

    println!("{}, {}", s, len); // ok
}

fn foo(s: &String) -> usize {
    s.len() // copy
}
```

[イメージ図](https://doc.rust-lang.org/book/ch04-02-references-and-borrowing.html#references-and-borrowing)

この時、関数 `foo`は `s`の所有権は移動していないことに注目

所有者ではないため、 `foo` が `s`を削除(`drop`)することがない

これを `brrowing`(借用)と呼ぶ

実生活でも人から借りたものは使い終わったら返さないといけません(戒

ただし、上記の例では借用しているものを変更することが出来ないことに注意

## 可変参照: mutable references

```rust
fn main() {
    let mut s = String::from("hello");

    change(&mut s);

    println!("{}", s);
}

fn change(some_string: &mut String) {
    some_string.push_str(", world");
}
```

1. `s`が `mut`である
1. `&mut s`とすることで、可変参照を作成し、
   `&mut String`で可変参照を受け入れている

可変参照には1つだけ重大な制限がある

特定のスコープ内の特定のデータへの可変参照は1つしか持てない

```rust
let mut s = String::from("hello");

let r1 = &mut s;
let r2 = &mut s; // fail

println!("{}, {} and {}", r1, r2);
```

この制限を持つことの利点は、Rustがコンパイル時にデータの競合を防ぐことができることにある

データの競合は次の3つの動作が発生したときに起きる

- 2つ以上のポインターが同じデータに同時にアクセスする
- 少なくとも1つのポインターがデータへの書き込みに使用されている
- データへのアクセスを同期するための仕組みが無い

データの競合は予期しない動作を引き起こし、その修正も難しい...

Rustはデータ競合を伴うコードをコンパイルしないため、この問題を防げるb

中括弧を利用することで新しいスコープを作成し、複数の可変参照を許可できる

```rust
let mut s = String::from("hello");

{
    let r1 = &mut s;
}

let r2 = &mut s; // ok
```

可変参照と不変参照の組み合わせにも同様の制限がある

```rust
let mut s = String::from("hello");

let r1 = &s; // ok
let r2 = &s; // ok
let r3 = &mut s; // fail

println!("{}, {} and {}", r1, r2, r3);
```

上記のように不変参照がある間は、可変参照を持つことが出来ない

複数の不変参照は他へ影響を及ぼさないため、許可される

### 注意

参照の範囲は、その参照が最後に使用されるまで続く
(言い換えれば、最後に使用された後に影響を及ぼさない)

よって、下記のような場合にはコンパイルが通る

```rust
let mut s = String::from("hello");

let r1 = &s; // ok
let r2 = &s; // ok
println!("{} and {}", r1, r2);

let r3 = &mut s; // ok
println!("{}", r3);
```

ここでは `r1`と `r2`の範囲は直後の `println!`までである

これらのスコープは `r3`と重複しないため、許可される

### ぶら下がり参照: dangling referer

ポインターを使用する言語では、
開放済みのメモリを参照するダングリングポインターが発生することがある

Rustではコンパイル時に参照がダングリングしないことを保証する (すごい)

## 参照の規則

- いつでも1つの可変参照または任意の数の不変参照を使用できる
- 参照は常に有効でなければならない

## スライス型: the slice type

所有権を持たないデータ型

スライスを使用すると、コレクション全体ではなく、コレクション内の連続したシーケンスを参照できる（なんぞ？）

`Go`などの `slice`と同じようなものかな？

### 文字列スライス: string slices

文字列の一部への参照

```rust
let s = String::from("hello world");

let hello = &s[0..5];
let world = &s[6..11];
```

`[starting_index..ending_index]`を指定することにより、角括弧内の範囲をスライスできる

`starting_index <= n < ending_index`

```rust
let s = String::from("hello");

let slice = &s[..2]; // same &[0..2];

                    // let len = s.len();
let slice = &s[2..] // same &[2..len];

let slice = &s[..] // same &[0..len];
```

※ 文字列スライスはUTF-8文字境界で発生しないといけないため、
マルチバイト文字の途中で文字列スライスを作成しようとするとプログラムはエラー終了する

`string slice`は、 `&str`と記述する

```rust
fn first_word(s: &String) -> &str {
    let bytes = s.as_bytes();

    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
	    return &s[0..i];
        }
    }

    &s[..]
}
```

Rustは参照の有効性を保証するため、下記のような場合にエラーになる

```rust
fn main() {
    let mut s = String::from("hello world");

    let word = first_word(&s);

    s.clear(); // error

    println!("{}", word);
}
```

空の文字列で最初の単語のインデックスを使用し続けようとすると、問題は後で発生するが、
スライスはこのバグを不可能にし、コードに問題があることをより速く知らせる(直訳)

不変参照がある場合、可変参照を取得できない

スライスは不変参照にあたり、
`clear`は可変参照の取得を試みるが、Rustはこれを許可出来ない

### 文字列リテラルはスライスである

```rust
let s = "hello, wordl";
```

この `s` は `&str` (文字列スライス)であり、 文字列スライスは不変参照である

これは文字列リテラルが不変である理由でもある

### 引数としての文字列スライス

引数に文字列スライスを利用することで、 `String` と
`&str`の両方で関数を使うことができるようになる

```rust
fn first_word(s: &str) -> &str {
```

文字列への参照の代わりに、文字列スライスを受け取るように関数を定義すると、APIがより一般的で便利になる

## その他のスライス: other slice

文字列の一部を参照したいように、配列の一部を参照したい場合がある

```rust
let a = [1, 2, 3, 4, 5];

let slice = &a[1..3];
```

このスライスの型は `&[i32]`である

これは文字列スライスと同じように機能する

## 要約

所有権、譲渡、借用及びスライスの概念により、コンパイル時にRustプログラムのメモリの安全性が確保される

Rustは他の言語と同じ方法でメモリ使用量を制御できるが、
データの所有者が範囲外になったときに自動的に clean
upを行うため、余分なコードを記述してデバッグする必要がなくなる

## 参考

- [The Rust Programming Language: 4. Understanding Ownership](https://doc.rust-lang.org/book/ch04-00-understanding-ownership.html)
