---
layout: layouts/blog.njk
title: AssemblyScriptを用いて安全にプラグイン機能を提供する
draft: false
tags:
  - blog
categories:
  - AssemblyScript
  - WebAssembly
---

AssemblyScriptはブラウザでも実行することができる．

AssemblyScriptを利用してプラグインを実装する機能を安全にユーザーに提供することができるのではないか?
また，ユーザーが実装したプラグイン定義を書くことができるのではないか?

```ts
declare function callback(result: i32): void;

declare function add(a: i32, b: i32): void;

declare function log(message: string): void;

export function run(): void {
  add(1, 2);
  callback(3);
  log("Hello");
}
```

`@external`を用いてリソースへのアクセス方法を定義できる．

`string`のglueコードと`--importMemory`のオプションが同時に有効にならない．
これは多分バグ

```diff
  const adaptedImports = {
    app: Object.assign(Object.create(__module0), {
      log(message) {
        // assembly/index/log(~lib/string/String) => void
        message = __liftString(message >>> 0);
        __module0.log(message);
      },
    }),
+   env: imports.env,
  };
```

ユーザーにはAssemblyScriptを用いてブラウザでのデバッグ機能を提供しつつ，実際のプラグインはAssemblyScriptを通してビルドしたWasmをサーバーで実行する，ということがどうもできそう．
