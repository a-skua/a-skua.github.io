---
layout: layouts/blog.njk
title: "Rust覚書9: ジェネリック型"
tags:
  - blog
categories:
  - rust
---

全てのプログラミング言語には概念の重複を効果的に処理するためのツールがある

Rustにはそのようなツールの１つにジェネリックがある
(`Option<T>`, `Vec<T>`, `HashMap<K, V>`)

## 関数を抽出し、重複を排除する: removing duplication by extracting a function

```rust
fn main() {
    let number_list = vec![34, 50, 25, 100, 65];

    let mut largest = number_list[0];

    for number in number_list {
        if number > largest {
            largest = number;
        }
    }

    println!("The largest number is {}", largest);

    let number_list = vec![102, 34, 6000, 89, 54, 2, 43, 8];

    let mut largest = number_list[0];

    for number in number_list {
        if number > largest {
            largest = number;
        }
    }

    println!("The largest number is {}", largest);
}
```
このコードは動作するが、コードの重複は退屈でエラーが発生しやすい

この重複をなくすために、パラメーターで指定された整数のリストを操作する関数を定義することにより、
抽象化を作成できる
```rust
fn largest(list: &[i32]) -> i32 {
    let mut largest = list[0];

    for &item in list {
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

    let number_list = vec![102, 34, 6000, 89, 54, 2, 43, 8];

    let result = largest(&number_list);
    println!("The largest number is {}", result);
}
```
ここでは、最大数を見つけるコードを`largest`という名前の関数に抽出している

`largest`関数には`list`と呼ばれる引数があり、
これは関数に渡す可能性のある`i32`値の具体的なスライスを表す

## ジェネリックデータ型: generic data types
ジェネリックを使用し、
関数シグネチャや構造体などのアイテムの定義を作成し、
様々な具体的なデータ型で使用できる

## 関数定義: in function definitions
ジェネリックを使用する関数を定義する場合、
通常は引数のデータ型と戻り値を指定する関数シグネチャにジェネリックを配置する
```rust
fn largest_i32(list: &[i32]) -> i32 {
    let mut largest = list[0];

    for &item in list.iter() {
        if item > largest {
            largest = item;
        }
    }

    largest
}

fn largest_char(list: &[char]) -> char {
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

    let result = largest_i32(&number_list);
    println!("The largest number is {}", result);

    let char_list = vec!['y', 'm', 'a', 'q'];

    let result = largest_char(&char_list);
    println!("The largest char is {}", result);
}
```
`largest_i32`と`largest_char`は同じコードを持っているので、
単一の関数にジェネリック型パラメータを導入することで
重複を排除できる

新しい関数で型をパラメータ化するには、関数の値のパラメータの場合と同様に、
型パラメータに名前を付ける必要がある

型パラメータ名として任意の識別子を使用できる

ただし、慣例によりRustのパラメータ名は短く、多くの場合は単なる文字であり、
Rustの型命名規則はCamelCaseであるため、`T`を使用する

`T`は`Type`の略で、
ほとんどのRustプログラマーのデフォルトの選択肢である

関数の中でパラメータを使用する場合、
コンパイラがその名前の意味を把握できるように署名でパラメータ名を宣言する必要がある

同様に、関数シグネチャで型パラメータ名を使用する場合、使用する前に型パラメータ名を宣言する必要がある(?)

次のように、関数名と引数リストの間に`<>`内に型名宣言を配置する

```rust
fn largest<T>(list: &[T]) -> T {
```

## 構造体の定義: in struct definitions
`<>`構文を使って、１つ以上のフィールドでジェネリック型を使用する構造体を定義することもできる

```rust
struct Point<T> {
    x: T,
    y: T,
}

fn main() {
    let integer = Point { x: 5, y: 10 };
    let float = Point { x: 1.0, y: 4.0 };
}
```

`x`と`y`に異なる型を持たせるには、
複数のジェネリック型パラメータを使用する

```rust
struct Point<T, U> {
    x: T,
    y: U,
}

fn main() {
    let both_integer = Point { x: 5, y: 10 };
    let both_float = Point { x: 1.0, y: 4.0 };
    let integer_and_float = Point { x: 5, y: 4.0 };
}
```
定義では、必要なだけ多くのジェネリック型パラメータを使用できるが、
2,3子以上使用すると可読性が低下する

コードに多くのジェネリック型が必要な場合、
コードをより小さな部品に再構築する必要がある可能性がある

## 列挙定義: in enum definitions

```rust
enum Option<T> {
    Some(T),
    None,
}
```
```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```
保持する値の型のみが異なる複数の構造体または列挙型を定義してコード内の状況を認識したい場合、
代わりにジェネリック型を使用して重複を回避できる

## メソッド定義

```rust
struct Point<T> {
    x: T,
    y: T,
}

impl<T> Point<T> {
    fn x(&self) -> &T {
        &self.x
    }
}

fn main() {
    let p = Point { x: 5, y: 10 };

    println!("p.x = {}", p.x());
}
```
ここでは、`x`という名前のメソッドを定義し、フィールド`x`への参照を返している

`impl`の直後に`T`を宣言する必要があることに注意

`impl`の後に`T`をジェネリック型として宣言することで、
Rustは`Point`の山括弧内の型をジェネリック型であることを識別できる

ジェネリック型の`Point<T>`にではなく、
`Point<f32>`にメソッドを実装する

```rust
impl Point<f32> {
    fn distance_from_origin(&self) -> f32 {
        (self.x.powi(2) + self.y.powi(2)).sqrt()
    }
}
```

このコードは`Point<f32>`型にメソッドがあり、
`T`が`f32`型では`Point<T>`の他のインスタンスにはこのメソッドが定義されていないことを意味する

```rust
struct Point<T, U> {
    x: T,
    y: U,
}

impl<T, U> Point<T, U> {
    fn mixup<V, W>(self, other: Point<V, W>) -> Point<T, W> {
        Point {
            x: self.x,
            y: other.y,
        }
    }
}

fn main() {
    let p1 = Point { x: 5, y: 10.4 };
    let p2 = Point { x: "Hello", y: 'c'};

    let p3 = p1.mixup(p2);

    println!("p3.x = {}, p3.y = {}", p3.x, p3.y);
}
```

## ジェネリックを使用下コードのパフォーマンス
Rustではジェネリック型を使用することによる
コードの実行速度低下はない

Rustは、コンパイル時にいジェネリックを使用しているコードの単相化(monomorphization)
を実行することでこれを実現している

単相化とは、コンパイル時に使用される具体的な型を入力するこにより、
ジェネリックコードを特定のコードに変換するプロセスである

このプロセスはジェネリック関数を作成するために使用した手順の逆を行う

コンパイラはジェネリックコードが呼び出される全ての場所を調べ、
ジェネリックコードが呼び出される具象型のコードを生成する

```rust
let integer = Some(5);
let float = Some(5.0);
```

Rustがこのコードをコンパイルすると、単相化が実行される

Rustは`Option<T>`を`Option_i32`と`Option_f64`に展開し、
ジェネリック定義を特定のものに置き換える

```rust
enum Option_i32 {
    Some(i32),
    None,
}

enum Option_f64 {
    Some(f64),
    None,
}

fn main() {
    let integer = Option_i32::Some(5);
    let float = Option_f64::Some(5.0);
}
```

単相化のプロセスにより、Rustのジェネリックは実行時に非常に効率的になる
