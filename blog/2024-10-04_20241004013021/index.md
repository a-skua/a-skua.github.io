---
layout: layouts/blog.njk
title: go:wasmexportディレクティブの追加
draft: true
tags:
  - blog
categories:
- Golang
- WebAssembly
---

[GitHub Issue](https://github.com/golang/go/issues/65199)

## 背景

> #38248 defined a new compiler directive, go:wasmimport, for interfacing with host defined functions. This allowed calling from Go code into host functions, but it’s still not possible to call from the WebAssembly (Wasm) host into Go code.

[#38248](https://github.com/golang/go/issues/38248)で新しいコンパイラディレクティブである`go:wasmimport`が定義されました．
これはGoのコードがホストの関数を呼ぶことを許可するものですが，WebAssemblyのホストからGoのコードを呼ぶことはできません．
