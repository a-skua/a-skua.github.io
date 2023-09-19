---
layout: layouts/blog.njk
title:  WebAssembly System Interface (README)
draft: true
tags:
  - blog
categories:
  - WebAssembly
  - 翻訳
---

[WebAssembly System Interface (README)](https://github.com/WebAssembly/WASI/blob/main/README.md)
の翻訳．

> The WebAssembly System Interface (WASI) is a set of APIs for WASI being developed for eventual standardization by the WASI Subgroup, which is a subgroup of the WebAssembly Community Group.

WebAssemblyシステムインターフェースはWebAssemblyコミュニティグループのサブグループである WASI サブグループによって最終的な標準化を進められているAPIセットです．

> WASI started with launching what is now called Preview 1, an API using the witx IDL, and it is now widely used. Its major incluences are POSIX and CloudABI.

WASIはプレビュー1と呼ばれている witx IDL(?)を使用したAPIの立ち上げから始まり，現在は広く使われています．
これらは主に POSIXとCloudABIの影響を受けています．

> WASI Preview 2 is now in development, which is a modular collection of APIs defined with the Wit IDL, and it incorporates many of the lessons learned from Preview 1, including adding support for a wider range of source languages, modularity, a more expressive type system, virtualizability, and more.

Wit IDLで定義されたモジュラーコレクションのAPIであるWASIプレビュー2を現在開発しています．
これにはプレビュー1からの多くの教訓が組み込まれており，モジュール性，より表現豊かな型システム，仮想化などより幅広いソース言語のサポートを含んでいます．

> ## Find the APIs
> Development of each API happens in its own repo, which you can access from the proposals list.

## APIを見つけるには
各APIの開発は独自のリポジトリにて行われており，プロポーザル一覧からアクセスできます．

> This repo is for general discussion, as well as documenting how we work and high-level goals.

このリポジトリは一般的なディスカッション用だけでなく，私たちの取り組み方と高レベルの目標をドキュメント化するものでもあります．

> ## Propose a new API
> If you would like to create a new proposal, get started with our Contributing guide.

## 新しいAPIのプロポーザル
もし新しいプロポーザルを作成しようとしているのであれば，コントリビュートガイドから始めてください．

> All new API proposals should use the new format and the new repo structure that is shown in the proposal template.

全ての新しいAPIプロポーザルはプロポーザルテンプレートに示されている新しいフォーマットと新しいリポジトリ構造を使用する必要があります．

> See the Wit in WASI document for more information about using Wit for WASI proposals.

WASIプロポーザルにWitを使用する方法の詳細はWit in WASIドキュメントを参照してください．

> ## WASI High Level Goals
> (In the spirit of WebAssembly's High-Level Goals.)

(TODO)

> 1. Define a set of portable, modular, runtime-independent, and WebAssembly-native APIs which can be used by WebAssembly code to interact with the outside world. These APIs preserve the essential sandboxed nature of WebAssembly through a Capability-based API design.
> 2. Specify and implement incrementally. Start with a Minimum Viable Product (MVP), then adding additional features, prioritized by feedback and experience.
> 3. Supplement API designs with documentation and tests, and, when feasible, reference implementations which can be shared between wasm engines.
> 4. Make a great platform:
>    - Work with WebAssembly tool and library authors to help them provide WASI support for their users.
>    - When being WebAssembly-native means the platform isn't directly compatible with existing applications written for other platforms, design to enable compatibility to be provided by tools and libraries.
>    - Allow the overall API to evolve over time; to make changes to API modules that have been standardized, build implementations of them using libraries on top of new API modules to provide compatibility.

> ## WASI Design Principles
> #### Capability-based security
> WASI is designed with capability-based security principles, using the facilities provided by the Wasm component model. All access to external resources is provided by capabilities.

> There are two kinds of capabilities:
> - Handles, defined in the component-model type system, dynamically identify and provide access to resources. They are unforgeable, meaning there's no way for an instance to acquire access to a handle other than to have another instance explicitly pass one to it.
> - Link-time capabilities, which are functions which require no handle arguments, are used sparingly, in situations where it's not necessary to identify more than one instance of a resource at runtime. Link-time capabilities are interposable, so they are still refusable in a capability-based security sense.

> WASI has no ambient authorities, meaning that there are no global namespaces at runtime, and no global functions at link time.

> Note that this is a different sense of "capability" than Linux capabilities or the withdrawn POSIX capabilities, which are per-process rather than per-resource.

> #### Interposition
> Interposition in the context of WASI interfaces is the ability for a Webassembly instance to implement a given WASI interface, and for a consumer WebAssembly instance to be able to use this implementation transparently. This can be used to adapt or attenuate the functionality of a WASI API without changing the code using it.

> Component model interfaces always support link-time interposition. While WASI APIs are often implemented in hosts, they can also be implemented in Wasm, which may itself be a wrapper around the host. This may be used to implement attenuation, providing filtered access to the underlying host-provided functionality.

> Interposition is sometimes referred to as "virtualization", however we use "interposition" here because the word "virtualization" has several related meanings.

> #### Compatibility
> Compatibility with existing applications and libraries, as well as existing host platforms, is important, but will sometimes be in conflict with overall API cleanliness, safety, performance, or portability. Where practical, WASI seeks to keep the WASI API itself free of compatibility concerns, and provides compatibility through libraries, such as WASI libc, and tools. This way, applications which don't require compatibility for compatibility's sake aren't burdened by it.

> #### Portability
> Portability is important to WASI, however the meaning of portability will be specific to each API.

> WASI's modular nature means that engines don't need to implement every API in WASI, so we don't need to exclude APIs just because some host environments can't implement them. We prefer APIs which can run across a wide variety of engines when feasible, but we'll ultimately decide whether something is "portable enough" on an API-by-API basis.

> #### Modularity
> WASI will include many interfaces that are not appropriate for every host environment, so WASI uses the component model's worlds mechanism to allow specific sets of APIs to be described which meet the needs of different environments.
