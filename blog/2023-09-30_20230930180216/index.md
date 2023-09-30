---
layout: layouts/blog.njk
title: Legacy WASI docs
tags:
  - blog
categories:
  - WebAssembly
  - 翻訳
---

[Legacy WASI docs](https://github.com/WebAssembly/WASI/blob/main/legacy/README.md)の和訳．

> This directory documents the "preview0" and "preview1" iterations of WASI.

このディレクトリは WASIの `preview0`と`preview1`のイテレーションドキュメントです．

> Preview0 corresponded to the import module name wasi_unstable. It was also called snapshot_0 in some places. It was short-lived, and the changes to preview1 were minor, so the focus here is on preview1.

プレビュー0は`wasi_unstable`のモジュール名に対応しています．
これは `snapshot_0`と呼ばれることがあります．
これは短命かつプレビュー1への変更は軽微だったため，ここではプレビュー1にフォーカスします．

> Preview1 corresponds to the import module name wasi_snapshot_preview1.

プレビュー1は `wasi_snapshot_preview1`のモジュール名に対応しています．

> There was some work under the name "ephemeral" towards an update of preview1 however it is no longer being actively developed. The name "preview2" now refers to the new wit-based iteration of WASI instead.

プレビュー1のアップデートに向けて `ephemeral`という名称でいくつかの作業がお壊れていましたが，長らく活発な開発はおこなれていません．
代わりに現在プレビュー2と呼ばれている新しいWitベースのWASIイテレーションを参照してください．

> Preview1 was defined using the witx IDL and associated tooling. Witx was an s-expression-based IDL derived from WebAssembly's wat text format, adding several extensions. It had a low-level C-like type system that emphasized raw pointers, and callees were expected to have access to the caller's entire linear memory, exported as "memory". It also had an implied global file descriptor table.

プレビュー1はあWitx IDLと関連するツールを使用して定義されていました．
WitxはWebAssemblyのWatにいくつかの拡張を追加した派生のS式ベースのIDLテキストフォーマットです．
これは低レベルのCのような生ポインタを強調した型システムで，呼び出し先はエクスポートされた「メモリ」である呼び出し元の線形メモリにアクセスできることを期待されていました．
また，暗黙のグローバルなファイルでスクリプタテーブルもありました．

> Some features in preview1 were not widely supported by engines:
> - The proc_raise function, because Wasm itself has no signal-handling facilities, and a process wishing to terminate abnormally typically uses a Wasm trap instead of calling proc_raise.
> - The process_cputime_id and thread_cputime_id, because in many engines, Wasm instances are not one-to-one with host processes, so the usual host APIs aren't sufficient to implement these.

プレビュー1のいくつかの機能は，ランタイムで広くサポートされませんでした．
- `proc_raise`関数: Wasm自体にシグナルハンドリング機能がないため，プロセスが異常終了したい場合は通常Wasmのトラップで代用します．
- `process_cputime_id`と `thread_cputime_id`: 多くのエンジンでWasmインスタンスとホストプロセスが1対1ではないため，通常のホストAPIではこれらを実装するのに十分ではありません．

> One function has been added to preview1:
> - sock_accept, allowing limited socket use cases to be supported. Sockets support with listen and connect is being added in preview2.

プレビュー1に追加された1つの機能:
- `sock_accept`: 制限されたソケットを使用するケースを許可することできるようにします．`listen`と`connect`の使用するソケットのサポートがプレビュー2に追加されています．
