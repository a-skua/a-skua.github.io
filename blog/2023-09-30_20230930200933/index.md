---
layout: layouts/blog.njk
title: WASI Application ABI
tags:
  - blog
categories:
  - WebAssebmly
  - 翻訳
---

[WASI Application ABI](https://github.com/WebAssembly/WASI/blob/main/legacy/application-abi.md)の和訳．

> In addition to the APIs defined by the various WASI modules there are also
> certain expectations that the WASI runtime places on an application that
> wishes to be portable across WASI implementations.

さまざまなWASIモジュールによって定義されたAPIに加えて，WASIランタイム上のWASI実装間で移植可能であることを望んでいるアプリケーションに対してある種の期待もあります．

> This document describes how a conforming WASI application is expected to
> behave in terms of lifecycle (startup, shutdown, etc) and any exports it is
> expected to include.

このドキュメントはどのように適合したWASIアプリケーションがライフサイクル(StartupやShutdownなど)の観点から動作することが期待されているのか，どんなエクスポートが含まれてれいることを期待しているかを説明します．

> ## Current Unstable ABI
>
> There are two kinds of modules:

## 現在の非安定版ABI

モジュールは2種類あります:

> - A command exports a function named _start, with no arguments and no return
  > values. _start is the default export which is called when the user doesn't
  > select a specific function to call. Commands may also export additional
  > functions, (similar to "multi-call" executables), which may be explicitly
  > selected by the user to run instead. Except as noted below, commands shall
  > not export any mutable globals, tables, or linear memories. Command
  > instances may assume that they will be called from the environment at most
  > once. Command instances may assume that none of their exports are accessed
  > outside the duration of that call.

- コマンドは引数の戻り値のない`_start`と呼ばれる関数をエクスポートします．

  `_start`はデフォルトエクスポートで，ユーザーが実行する関数を選択しなかった場合に実行されます．
  コマンドは追加の関数をエクスポートすることができ，代わりに実行できるようにユーザーが指定することもできます．

  以下に記載されていることを除き，コマンドは変更可能なグローバル，テーブル，線形メモリをエクスポートしません．

  コマンドインスタンスは最大1回環境から呼ばれると想定します．
  コマンドインスタンスはその呼び出し期間外に外部からエクスポートにアクセスされないと想定します．

> - All other modules are reactors. A reactor may export a function named
  > _initialize, with no arguments and no return values. If an _initialize
  > export is present, reactor instances may assume that it will be called by
  > the environment at most once, and that none of their other exports are
  > accessed before that call. After being instantiated, and after any
  > _initialize function is called, a reactor instance remains live, and its
  > exports may be accessed.

- 全ての他のモジュールはリアクターです．リアクターは
  `_initialize`と呼ばれる引数も戻り値も持たない関数をエクスポートできます．

  `_initialize`エクスポートが存在する場合，リアクターインスタンスは環境から最大1回呼び出されると想定でき，その呼び出しの前に他のエクスポートにはアクセスされません．

  インスタンス化された後，`_initialize`関数が呼ばれた後，リアクターインスタンスは生き続け，そのエクスポートにアクセスできます．

> These kinds are mutually exclusive; implementations should report an error if
> asked to instantiate a module containing exports which declare it to be of
> multiple kinds.

これらの種類のモジュールは互いに排他的です．
もしインスタンスが複数の種類のモジュールを定義するモジュールのインスタンス化を要求する場合，エラーを報告する必要があります．

> Regardless of the kind, all modules accessing WASI APIs also export a linear
> memory with the name memory. Data pointers in WASI API calls are relative to
> this memory's index space.

種類を問わず，WASI
APIにアクセスする全てのモジュールは`__indirect_function_table`という名前のテーブルもエクスポートします．
WASI API呼び出しの関数ポインタはこのテーブルのインデックス空間と相対です．

> Regardless of the kind, all modules accessing WASI APIs also export a table
> with the name __indirect_function_table. Function pointers in WASI API calls
> are relative to this table's index space.

> When _start or _initialize is called, environments shall provide file
> descriptors with indices 0, 1, and 2 representing stream resources for
> standard input, standard output, and standard error. Environments may provide
> additional "preopen" file descriptors that can be inspected with
> fd_prestat_get and fd_prestat_dir_name. These resources may be closed at any
> time.

`_start`もしくは
`_nitialize`が呼ばれたとき，環境はストリームリソース(標準入力，標準出力，標準エラー)を表すファイルディスクリプタのインデックス0,
1, 2を提供します．
環境によっては`fd_prestat_get`と`fd_prestat_dir_name`を走査できる場合に追加のファイルディスクリプタ
`preopen`を提供します． これらのリソースはいつでも閉じられる可能性があります．

> Environments shall not access exports named __heap_base or __data_end.
> Toolchains are encouraged to avoid providing these exports.

環境は
`__heap_base`と`__data_end`と呼ばれるエクスポートにはアクセスしてはいけません．
ツールチェーンではこれらのエクスポートの提供を避けることが提供されます．

> In the future, as the underlying WebAssembly platform offers more features, we
> hope to eliminate the requirement to export all of linear memory or all of the
> indirect function table.

将来的に，根底にあるWebAssebmlyがより多くの機能を提供するため，全ての線形メモリと全ての間接関数テーブルの要件を廃止することを望みます．

> ## Planned Stable ABI
>
> There is ongoing discussion about what the stable ABI might look like:
>
> - #13
> - #19
> - #24

## 安定版ABIの計画

安定したABIについては議論が続いています:
