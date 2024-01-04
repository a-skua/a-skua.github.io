---
layout: layouts/blog.njk
title: Why the Component Model?
tags:
  - blog
categories:
  - WebAssembly
  - THe WebAssembly Component Model
  - 翻訳
---

[Why the Component Model?](https://component-model.bytecodealliance.org/design/why-component-model.html#why-the-component-model)の和訳．

> If you've tried out WebAssembly, you'll be familiar with the concept of a
> module. Roughly speaking, a module corresponds to a single .wasm file, with
> functions, memory, imports and exports, and so on. These "core" modules can
> run in the browser, or via a separate runtime such as Wasmtime or WAMR. A
> module is defined by the WebAssembly Core Specification, and if you compile a
> program written in Rust, C, Go or whatever for the browser, then a core module
> is what you'll get.

既に WebAssembly
使用しているのであれば，モジュールのコンセプトに馴染みがあるでしょう．
大雑把に言うと，関数，メモリ，インポート，エクスポートを持つモジュールは単一の
`.wasm` ファイルに対応します． これらの **コア**
モジュールはブラウザ，もしくはWasmtimeやWAMRといった異なるランタイム経由で実行できます．
モジュールは
[WebAssembly Core Specification](https://webassembly.github.io/spec/core/)に定義されており，RustやC，Goなどで書かれたプログラムをブラウザ向けにコンパイルすると，コアモジュールを得る事ができます．

> Core modules are, however, limited to describing themselves in terms of a
> small number of core WebAssembly types such as integers and floating-point
> numbers. Just as in native assembly code, richer types, such as strings or
> records (structs), have to be represented in terms of integers and floating
> point numbers, for example by the use of pointers and offsets. And just as in
> native code, those representations are not interchangeable. A string in C
> might be represented entirely differently from a string in Rust, or a string
> in JavaScript.

しかしながら，コアモジュールは整数や浮動点少数などを用いてコアモジュール自身を記述することに制限されています．
ネイティブアセンブリコード同様に，Stringやレコード(構造体)のような豊富な型をポインターやオフセットを使用して整数や浮動点少数で表現する必要があります．
そして同様に，これらの表現には互換性がありません．
Cの文字列はRustやJavaScriptの文字列とは異なる表現をされるかもしれません．

> For Wasm modules to interoperate, therefore, there needs to be an agreed-upon
> way for defining those richer types, and an agreed-upon way of expressing them
> at module boundaries.

Wasmモジュールを相互運用するには，豊富な型を表現するための合意された方法と，モジュール境界でそれらを表現する合意された方法が必要です．

> In the component model, these type definitions are written in a language
> called WIT (Wasm Interface Type), and the way they translate into bits and
> bytes is called the Canonical ABI (Application Binary Interface). A Wasm
> component is thus a wrapper around a core module that specifies its imports
> and outputs using such Interfaces.

コンポーネントモデルでは，型定義を[WIT](https://component-model.bytecodealliance.org/design/wit.html)言語を用いて行い，それらをビットやバイトに翻訳する方法を[Canonical ABI](https://component-model.bytecodealliance.org/design/canonical-abi.html)と呼びます．
Wasmコンポーネントはインターフェースを使用するコアモジュールのインポートとアウトプット仕様のラッパーです．

> The agreement of an interface adds a new dimension to Wasm portability. Not
> only are components portable across architectures and operating systems, but
> they are now portable across languages. A Go component can communicate
> directly and safely with a C or Rust component. It need not even know which
> language another component was written in - it needs only the component
> interface, expressed in WIT. Additionally, components can be linked into
> larger graphs, with one component satisfying another's dependencies, and
> deployed as units.

インターフェースの合意により，Wasmの移植性に新たな次元が生まれます．
コンポーネントはOSや異なるアーキテクチャ間で移植できるのではなく，異なる言語間でも移植できます．
Goのコンポーネントが直接かつ安全にCやRustのコンポーネントと通信できます．
別のコンポーネントがどんな言語で書かれているかを知る必要がなく，WITで表現されたコンポーネントインターフェスだけが必要です．
さらに，コンポーネントは1つのコンポーネントが他のコンポーネントの依存関係を満たすことで，より大きなグラフ(依存関係?)の中にリンクし，ユニットとしてデプロイできます．

> Combined with Wasm's strong sandboxing, this opens the door to yet further
> benefits. By expressing higher-level semantics than integers and floats, it
> becomes possible to statically analyse and reason about a component's
> behaviour - to enforce and guarantee properties just by looking at the surface
> of the component. The relationships within a graph of components can be
> analysed, for example to verify that a component containing business logic has
> no access to a component containing personally identifiable information.

Wasmの強力なサンドボックスと組み合わせることで更なる利点の扉を開きます．
数値や浮動小数点数より高位のセマンティクスを表現することによって，コンポーネントの動作を静的解析して推論可能になり，コンポーネントの表層を見るだけでプロパティを保証することを矯正できます．
コンポーネントグラフ内の関係を解析して，ビジネスロジックを含むコンポーネントが個人情報を含むコンポーネントにアクセスできないことを保証することを検証する事ができます．

> Moreover, components interact only through the Canonical ABI. Specifically,
> unlike core modules, components may not export Wasm memory. This not only
> reinforces sandboxing, but enables interoperation between languages that make
> different assumptions about memory - for example, allowing a component that
> relies on Wasm GC (garbage collected) memory to collaborate with one that uses
> conventional linear memory.

さらに，コンポーネントは Canonical ABIのみを通じて対話します．
具体的には，コアモジュールとは異なり，コンポーネントはメモリをエクスポートできないかもしれません．
これはサンドボックスを強化するだけでなく，GCに依存するコンポーネントが従来の線形メモリを使用するコンポーネントと連携できるようにしたりと，メモリについて異なる前提の言語間の通信を可能にします．

> Now that you have a better idea about how the component model can help you,
> take a look at how to build components in your favorite language!

これで，コンポーネントモデルについて理解できたので，好きな言語でコンポーネントモデルをどうビルドするのかを見てみましょう．

> ⓘ For more background on why the component model was created, take a look at
> the specification's goals, use cases and design choices.

ⓘコンポーネントモデルが作られた背景をより知るには，仕様の目標(
[goals](https://github.com/WebAssembly/component-model/blob/main/design/high-level/Goals.md)
)，ユースケース(
[use cases](https://github.com/WebAssembly/component-model/blob/main/design/high-level/UseCases.md)
)，設計上の選択(
[design choices](https://github.com/WebAssembly/component-model/blob/main/design/high-level/Choices.md)
)をみてみましょう．
