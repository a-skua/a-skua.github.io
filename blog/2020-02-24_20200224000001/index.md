---
layout: layouts/blog.njk
title: "Rust覚書8: エラーハンドリング"
tags:
  - blog
categories:
  - rust
---

Rustの信頼性への取り組みはエラー処理(error handling)にも及ぶ

エラーはソフトウェアの宿命であるため、
Rustには何かがうまく行かない状況を処理するための多くの機能がある

多くの場合、Rustではエラーの可能性を認識し、
コードをコンパイルする前に何らかのアクションを取る必要がある

この要件により、本番環境にコードをデプロイする前にエラーを発見し、
適切に処理できるようになるため、 プログラムの堅牢性が高まる

Rustは、エラーを２つの主要なカテゴリーに分類する (回復可能か、回復不可能)

ファイルが見つからないエラーなど、
回復可能なエラーの場合はユーザーに問題を報告し、 操作を再試行するのが妥当である

回復不可能なエラーは、
常に配列の終わりを超えて場所にアクセスしようとするようなバグのような症状

ほとんどの言語は、これら２種類のエラーを区別せず、
例外などのメカニズムを使用して両方を同じ方法で処理する (Goは区別してるよ！)

Rustには例外はない

代わりに、 回復可能なエラー型`Result<T,E>`と
プログラムで回復不可能なエラーが発生したときに実行を停止する
`panic!`マクロがある

## `panic!`に伴う回復不能なエラー: unrecoverable errors with `panic!`

時々、コードに悪いことが起こり、 それに対してできることが何もない

この場合、Rustは`panic!`マクロを持っている

`panic!`マクロを実行した時、 プログラムは失敗メッセージを出力、
スタックを開放し、 クリーンアップしてから終了する

これは、アルシュのバグが検出され、プログラマがエラーを処理する方法が明確得ない場合に
最もよく発生する

## パニックに応じてスタックを巻き戻すか中止する: unwinding the stack or aborting in response to a panic

デフォルトでは、パニックが発生するとプログラムは巻き戻しを開始する

Rustはスタックをさかのぼって、 検出した各関数のデータをクリーンアップする

しかし、この後戻りとクリーンアップは時間がかかる

別の方法は、すぐに中止することで、クリーンアップせずにプログラムを終了する

プログラムが使用していたメモリは、OSによってクリーンアップする必要がある

もし、プロジェクトで結果のバイナリをできるだけ小さくする必要がある場合、
`Cargo.toml`ファイルの適切な`[profile]`セッションに`panic = 'abort'`を追加することで、
巻き戻し`unwinding`から打ち切り`abort`に切り替えることができる

リリースモードでパニックで中止する場合は、次のようにする

```toml
[profile.release]
panic = 'abort'
```

`panic!`の呼び出し

```rust
fn main() {
    panic!("crash and burn");
}
```

`panic!`を呼び出すと、最後の２行に原因となるエラーメッセージが含まれる

最初の行はパニックメッセージとパニックが発生したソースコード内の場所を示している

## `panic!`バックトレースを使用する: using a `panic!` backtrace

```rust
fn main() {
    let v = vec![1, 2, 3];

    v[99];
}
```

この場合、Rustはパニックを起こす (無効なインデックスを渡しているため)

Cのような他の言語の場合、 このようなアクセスは正常に動作しようとする

これはバッファオーバーリードと呼ばれ攻撃者が配列の後に保存されては行けないデータを読み取るように
インデックスを操作できる場合、セキュリティの脆弱性につながる可能性がある

エラーメッセージの２行目の行は、環境変数`RUST_PACKTRACE`を設定して、
エラーの原因となった正確なバックトレースを取得できることを示している

バックトレースは、エラーポイントに到達するために呼び出された全ての関数リストである

```shell
$ RUST_PACKTRACE=1 cargo run
```

この情報でバックトレースを取得するには、デバッグシンボルを有効にする必要がある

`--release`フラグなしで`cargo run`,
`cargo build`を使うとデバッグシンボルはデフォルトで有効になる

## `Result`を伴う回復可能なエラー: recoverable errors with result

ほとんどのエラーは、プログラムを完全に停止する必要があるほど深刻ではない

機能が失敗したときに、簡単に解釈して対応できる理由がある場合がある

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

`T`は`Ok`バリアント内の成功事例で消される値の型を表し、
`E`は`Err`バリアント内の失敗事例で返されるエラーの型を表す

```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt");
}
```

`File::open`が`Result`を返すことをどのように知ることができるのか？

ドキュメントを見るか、コンパイラに問い合わせることができる

関数の戻り値の型ではないことがわかっている型注釈を`f`に指定して、
コンパイルしようとすると、コンパイラは型が一致しないことを通知する

```rust
let f: u32 = File::open("hello.txt");
```

`T`には成功値の`std::fs::File`が入り、 `E`には`std::io::Error`が入る

`File::open`が成功した場合、変数`f`の値は、ファイルハンドルを含む`Ok`のインスタンスになる

失敗した場合、`f`の値は発生したエラーの種類に関する詳細情報を含む`Err`のインスタンスになる

```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt");

    let f = match f {
        Ok(file) => file,
        Err(error) => {
            panic!("Problem opening the file: {:?}", error)
        },
    };
}
```

`Option`列挙型と同様に、
`Result`列挙型とそのバリアントはデフォルトでスコープに取り込まれている

結果が`Ok`の場合、`Ok`バリアントから内部ファイル値を返し、そのファイルハンドル値を変数`f`に割り当てる

`match`後、ファイルハンドルを読み書きに使用できる

`match`のもう一つのアーム(`arm`)は`Err`値を取得するケースを処理する

ここでは、`panic!`マクロを読んでいる

## 様々なエラーマッチング: matching on defferent errors

次の例では、ファイルが存在しないために`File::open`が失敗した場合、
ファイルを作成し、新しいファイルにハンドルを返す

また、他の理由で失敗した場合は`panic!`を呼び出す

```rust
use std::fs::File;
use std::io::ErrorKind;

fn main() {
    let f = File::open("hello.txt");

    let f = match f {
        Ok(file) => file,
        Err(error) => match error.kind() {
            ErrorKind::NotFound => match File::create("hello.txt") {
                Ok(fc) => fc,
                Err(e) => panic!("Problem creating the file: {:?}", e),
            },
            other_error => panic!("Problem opening the file: {:?}", other_error),
        },
    };
}
```

`File::open`が`Err`バリアント内で返す値のタイプは`io::Error`で、
これは標準ライブラリによって提供される構造体

この構造体には、
`io::ErrorKind`値を取得するために呼び出すことができるメソッドの種類がある

列挙型`io::ErrorKind`は標準ライブラリから提供され、
io操作から生じる可能性のある様々な種類のエラーを表すバリアントがある

`error.kind()`によって返される値が`ErrorKind::NotFound`バリアントである場合、
`File::create`を試みる (`File::create`も失敗する可能性がある)

`match`表現は非常に便利ではあるが、非常に原始的(primitive)でもある

`Result<T, E>`には多くのメソッドがすでにあり、それらを使用することでより簡潔に書くことが可能

```rust
use std::fs::File;
use std::io::ErrorKind;

fn main() {
    let f = File::open("hello.txt").unwrap_or_else(|error| {
        if error.kind() == ErrorKind::NotFound {
            File::create("hello.txt").unwrap_or_else(|error| {
                panic!("Problem creating the file: {:?}", error);
            })
        } else {
            panic!("Problem opening the file: {:?}", error);
        }
    });
}
```

これらのメソッドの多くは、エラーに対処するときに、ネストされた巨大な一致表現をクリーンアップできる

## エラー時のパニックのショートカット:`unwrap`と`expect`: shortcuts for panic on error: unwrap and expect

`match`を使っても十分に機能するが、すこし冗長になる可能性がある

`Result<T, E>`型には、様々なタスクを実行するために定義された多くのヘルパーメソッドがある

`unwrap`は、`Ok`内の値を返し、
結果が`Err`バリアントの場合、`panic!`マクロを呼び出す

```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt").unwrap();
}
```

`expect`も`unwrap`に似ているが、 こちらは`panic!`のエラーメッセージを選択できる

```rust
use std::fs::File;

fn main() {
    let f = File::open("hello.txt").expect("Failed to open hello.txt");
}
```

`expect`のほうが、エラーメッセージは親切である

複数の場所で`unwrap`を使用する場合、
パニックを引き起こす全ての`unwrap`が同じメッセージを出力するため、
どの`unwrap`がパニックを引き起こしているのかを正確に把握するのに時間がかかる

## エラーの伝播: propagating errors

実装が失敗する可能性のあるものを呼び出す関数を作成する場合、この関数内でエラーを処理する代わりに、
呼び出し元のコードにエラーを嘉永して処理を決定できる

これはエラーの伝播として知られており、呼び出し元により多くの制御を提供する

コードのコンテキストで利用できる情報よりも、
エラーの処理方法を支持する情報またはロジックが多くなる場合がある

```rust
use std::io;
use std::io::Read;
use std::fs::File;

fn read_username_from_file() -> Result<String, io::Error> {
    let f = File::open("hello.txt");

    let mut f = match f {
        Ok(file) => file,
        Err(e) => return Err(e),
    };

    let mut s = String::new();

    match f.read_to_string(&mut s) {
        Ok(_) => Ok(s),
        Err(e) => Err(e),
    }
}
```

`Result<String, io::Error>`について

`T`を`String`、 `E`を`io::Error`とした `Result<T, E>`の値を返すことを意味する

`read_to_string`メソッドは、
`File::open`が成功した場合でも失敗する可能性があるため、 `Result`を返す

関数の途中で終了する場合、 明示的に`return`を記述する必要がある

この関数の戻り値にたいして、呼び出し元が何をするかはわからない

呼び出し元が何をしたいのかに関する十分な情報が無いため、
成功またはエラーの情報を全て上に伝達し、 適切に処理できるようにする

## エラーを伝播するためのショートカット: `?`演算子 : a shortcut for propagating errors: the `?` operator

`?`演算子を使って、より簡潔に記載することができる

```rust
use std::io;
use std::io::Read;
use std::fs::File;

fn read_username_from_file() -> Result<String, io::Error> {
    let mut f = File::open("hello.txt")?;
    let mut s = String::new();
    f.read_to_string(&mut s)?;
    Ok(s)
}
```

`?`演算子は、結果の値が`Ok`の場合、
`Ok`内の値がこの式から返され、プログラムが続行される

値が`Err`の場合、 `Err`値を呼び出し元のコードに伝播する

`?`演算子と一致表現には違いがある

エラー値は`?`演算子を呼び出すときに標準ライブラリで定義された`from`関数を通過する

この関数はエラーを別の型に変換するために使用される

`?`演算子が`from`関数を呼び出すと、受け取ったエラー型は現在の関数の戻り値で定義されたエラー型に変換される

これは、関数が失敗する可能性のある全ての方法を表す１つのエラー型を関数が返す場合に便利である

このように`?`演算子は多くの定型文を排除し、 関数の実装をより簡単にする

`?`の直後にメソッド呼び出しを連鎖させることによりより短縮することもできる

```rust
use std::io;
use std::io::Read;
use std::fs::File;

fn read_username_from_file() -> Result<String, io::Error> {
    let mut s = String::new();

    File::open("hello.txt")?.read_to_string(&mut s)?;

    Ok(s)
}
```

より短くする方法がある

```rust
use std::io;
use std::fs;

fn read_username_from_file() -> Result<String, io::Error> {
    fs::read_to_string("hello.txt")
}
```

ファイルを文字列に読み込むことはかなり一般的なそうさであるため、
Rustは便利な`fs::read_to_string`半数を提供している

## `Result`を返す関数で`?`演算子を利用できる: the `?` operator can be used in functions that return result

```rust
use std::error::Error;
use std::fs::File;

fn main() -> Result<(), Box<dyn Error>> {
    let f = File::open("hello.txt")?;

    Ok(())
}
```

`main`関数の戻り値は`()`か`Result<T, E>`か選ぶことができる

## `panic!`か`panic!`じゃないか: to `panic!` or not to `panic!`

どのようにパニックをよびだすか、`Result`を返すかを決定するべきか？

パニックになると、回復方法がない

パニックを呼び出す時、それは回復不可能と判断したことになる

`Result`を返すことを選択した場合、それの決定をしない

したがって、通常は`Result`を返すことが適切な選択である

まれに`Result`を返す代わりにパニックを起こすコードを記述するほうが適切な場合がある

## 例、プロトタイプコード、テスト: example, prototype code, and tests

いくつかの概念を説明するために例を書いている時、
例に堅牢なエラー処理コードを含めると例がわかりにくくなる可能性がある

同様に、エラーを処理する方法を決定する準備ができる前にプロトタイプを作成する時、
`unwrap`と`expect`メソッドが非常に便利である

これらは、プログラムをより堅牢にする準備が出来たときに、
コードに明確なマーカーを残す

テストでメソッド呼び出しが失敗した場合、そのメソッドがテスト中の機能ではない場合でも、
テスト全体が失敗するようにする

`pqnic!`はテストが失敗としてマークする方法であり、 起こるべきとこである

## コンパイラーよりも多くの情報を持っている場合: cases in which you have more information than the compiler

`Result`に`Ok`があることを保証する他のロジックがある場合、`unwrap`を呼び出すことも適切であが、
ロジックはコンパイラが理解するものではない

特定の状況では論理的に不可能だが、呼び出している操作は一般に失敗する可能性がある

もじコードを手動で検査し、Errバリアントが無いことを確認できる場合、
`unwrap`を呼び出しても問題はない

```rust
use std::net::IpAddr;

let home: IpAddr = "127.0.0.1".parse().unwrap();
```

明らかに、有効な値であることがわかっている場合、
ここで`unwrap`を使用しても構わない

ただし、ハードコードされた有効な文字列を使用しても解析メソッドの戻り値の型は変わらない

人が見て明らかに有効であるものを、判断することが出来ないため
(ここでいうIPアドレス)、 Errバリアントの可能性があるかのように`Result`を処理する

IPアドレスがハードコードされたものではなく、 ユーザーからものである場合、
より堅牢な方法で処理する必要がある

## エラー処理のガイドライン: guidelines for error handling

コードが悪い状態に陥る可能性がある場合は、
コードをパニック状態にすることをおすすめする

- 悪い状態は時々起こると予想されるものではない
- この時点以降のコードは、この悪い状態になっていないことに依存する必要がある
- 使用する型で、この情報をエンコードするいい方法がない

誰かがコードを呼び出し、意味をなさない値を渡す場合、パニックを呼び出すことが最善の選択である

また、開発中に修正できるよう、 ライブラリの使用者にコードのバグを警告する

同様に 制御出来ない外部コードを呼び出しており、
修正する方法がない無効な状態を返す場合、 多くの場合`panic!`は適切である

失敗が予想される場合は、`panic!`を起こすよりも、`Result`を返す方が適切である

コードが値に対して操作を実行するとき、コードは最初に値が有効であることを確認し、
値が有効でない場合はパニックする必要がある

これは主に安全上の利用うによるもので、 無効なデータを操作しようとすると、
コードが脆弱性にさらされる可能性がある

これが、範囲外のメモリアクセスを試みる場合に
標準ライブラリがパニックを呼び出す主な理由である

現在のデータ構造に属さないメモリにアクセスしようとすることは、一般的なセキュリティ問題である

多くの場合、関数には約定がある...
入力が特定の条件を満たす場合にのみ、その動作が保証される

その約定から外れる時、バグを示し、呼び出しコードが明示的に処理する必要がある種類のエラーではないため、
パニックは理にかなっている

実際、回復するコードを呼び出すための合理的な方法はなく、
呼び出し元のプログラマはコードを修正する必要がある

機能の約定、
特に違反がパニックを引き起こす場合はその機能のAPIドキュメントで説明する必要がある

ただし、全ての関数で多くのエラーチェックを行うと、 冗長で煩わしくなる

幸いなことにRustの型システムを使用し、 多くのチェックをすることができる

## 検証用のカスタム型の作成: creating custom types for validation

```rust
loop {
    // --snip--

    let guess: i32 = match guess.trim().parse() {
        Ok(num) => num,
        Err(_) => continue,
    };

    if guess < 1 || guess > 100 {
        println!("The secret number will be between 1 and 100.");
        continue;
    }

    match guess.cmp(&secret_number) {
    // --snip--
}
```

ここでは、1~100の範囲の入力チェックを行っている

しかし、この処理は退屈である(?)

(パフォーマンスに影響を及ぼす可能性もある)

代わりに、検証を繰り返すのではなく、新しい型を作成し、
検証を関数いに入れて方のインスタンスを作成する

```rust
pub struct Guess {
    value: i32,
}

impl Guess {
    pub fn new(value: i32) -> Guess {
        if value < 1 || value > 100 {
            panic!("Guess value must be between 1 and 100, got {}.", value);
        }

        Guess {
            value
        }
    }

    pub fn value(&self) -> i32 {
        self.value
    }
}<Paste>
```

構造体の値フィールドは、プライベートなので、getterにあたるパブリックメソッドが必要

モジュール外のコードは`Guess::new`関数を使用して、`Guess`のインスタンスを作成する必要がある
(`value`がプライベートなため)

これによって、チェックされていない値を持つことができなくなる

## 参考

- [The Rust Programming Language: Error Handling](https://doc.rust-lang.org/book/ch09-00-error-handling.html)
