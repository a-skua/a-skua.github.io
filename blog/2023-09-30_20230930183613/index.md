---
layout: layouts/blog.njk
title: Know your witx
tags:
  - blog
categories:
  - 翻訳
  - WebAssembly
---

[Know your witx](https://github.com/WebAssembly/WASI/blob/main/legacy/tools/witx-docs.md)の和訳．

> Witx is an experimental IDL. The text format is based on a text format
> associated with an early version of the module linking proposal text format,
> which at the time was called wit, though it is a different language than what
> we now call Wit. And that wit was in turn based on the wat format, which is
> based on S-expressions.

Witxは実験的なIDLです．
テキストフォーマットは[module linking proposal](https://github.com/WebAssembly/module-linking/)の初期バージョンに関連した当時は
`wit`と呼ばれていたテキストフォーマットをベースにしています．
現在私たちが[Wit](https://github.com/WebAssembly/component-model/blob/main/design/mvp/WIT.md)と呼んでいるものとは異なり，S式をベースとしたWatをベースにしています．

> Witx adds some features inspired by interface types, such as limited string
> and array arguments, and some features using for working with IDL files such
> as the ability to include one IDL file in another.

Witxは[interface types](https://github.com/WebAssembly/interface-types/blob/main/proposals/interface-types/Explainer.md)に触発され，制限されたも列や配列，IDLファイルのインクルード操作などのいくつかの機能を追加しています．

> The initial goal for witx was just to have a language suitable for expressing
> WASI APIs in, to serve as the vocabulary for proposing changes to existing
> APIs and proposing new APIs.

Witxの最初の目標は既存のAPIへの変更や新しいAPIの提案を行うための語彙としてWASI
APIを表現するのに適した言語だけでした．

> The WASI Subgroup is migrating away from witx and toward Wit, because Wit
> provides much better support for non-C-like languages, better support for API
> virtualization, it has a path to integrating async behavior into WASI APIs in
> a comprehensive way, and it supports much more expressive APIs, such as the
> ability to have strings and other types as return types in addition to just
> argument types. At this point, the tooling for Wit is also a lot more
> sophisticated and the Wit language and Canonical ABI have much more
> documentation.

WitはCライクではない言語へのより優れたサポート，優れたAPI仮想化のサポート，非同期操作のWASI
APIへの包括的な統合，より表現豊かなAPIのサポート，引数だけでなく，戻り値にも文字列やその他の型を返す機能などを提供するため，WASIサブグループは
WitxからWitへ移行しています.
この時点でWitのツールも遥かに洗練されており，[Wit language](https://github.com/WebAssembly/component-model/blob/main/design/mvp/WIT.md)と[Canonical ABI](https://github.com/WebAssembly/component-model/blob/main/design/mvp/CanonicalABI.md)により多くのドキュメントがあります．

> This document focused on the witx format.

このドキュメントはWitxフォーマットにフォーカスします．

> ## Return types
>
> Function declarations in witx can have a special expected type, which is a
> variant which represents either success or failure, and can return a specific
> type off value for each.

## 戻り値

Witxでは関数宣言に成功または失敗のどちらかを表すことができそれぞれの値をtype
off(omit?)できる特別な`expected` 型を持つことができます．

> For example, the fd_read function declaration in Preview1 contains this:

例えば，プレビュー1の `fd_read`の関数宣言は次のようなものが含まれています:

```txt
(result $error (expected $size (error $errno)))
```

> This declares a result named $error which returns a value with type $size on
> success, and a value with type $errno on failure.

この宣言は`$error`の戻り値は成功時には `$size`型，失敗時には
`$errno`型を返す`$error`という結果を表現しています．

> The expected mechanism assumes that the error value is an enum where 0
> indicates success, and as such it doesn't return an explicit descriminant
> value. In the ABI, the error type is returned as the return value and the
> success value is handled by adding an argument of pointer type for the
> function to store the result into.

`expected`のメカニズムはエラー値はenumであり`0`は成功を表し，明示的な説明は返しません．
APIでは，
`error`型は戻り値と結果を返す関数の場合はハンドルされたポインタ型の引数に成功値を追加します．

> The resulting ABI for fd_read looks like this:

処理された `fd_read`のABIは次のようになります．

```txt
__wasi_errno_t __wasi_fd_read(
    __wasi_fd_t fd,
    const __wasi_iovec_t *iovs,
    size_t iovs_len,
    __wasi_size_t *retptr0
);
```

> ## Pointers
>
> Witx supports two pointer types, pointer and const_pointer, which represent
> pointers into the exported linear memory named "memory". const_pointer in a
> function declaration documents that the function does not use the pointer for
> mutating memory. Similar to C, they can point to either a single value or an
> contiguous array of values.

## ポインタ

Witxはエクスポートされた`memory`という名称の線形メモリのポインタを表す`pointer`と`const_pointer`の2つのポインタ型をサポートします．
関数宣言ドキュメント中で`const_pointer`はその関数がポインタをメモリの変更に使用ないことを表します．
Cと同様に単一の値もしくは連続する配列の値を指すことができます．

> Pointer arguments use the @witx syntax inspired by the annotations proposal.

ポインタ引数は[annotations proposal](https://github.com/WebAssembly/annotations)に触発され，`@witx`構文を使用します．

> For example, the poll_oneoff function has these arguments:

例えば，`poll_oneoff`関数は次のような引数を持っています:

```txt
(param $in (@witx const_pointer $subscription))
(param $out (@witx pointer $event))
```

> Pointer values are expected to be aligned, to the alignment of their pointee
> type. If a misaligned pointer is passed to a function, the function shall
> trap.

ポインタ値は指示先の型に合わせて整列していることが期待されます.
もし誤ったポインタが関数に渡された場合，関数はトラップします．

> If an out-of-bounds pointer is passed to a function and the function needs to
> dereference it, the function shall trap rather than returning errno.fault.

範囲外のポインタが関数に渡され，関数が逆参照を必要する場合，関数は
`errno.fault`を返すのではなくトラップします．
