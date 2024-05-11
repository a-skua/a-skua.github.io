---
layout: layouts/blog.njk
title: Cloudflare WorkersでDartを動かす
tags:
- blog
categories:
- Dart
- Cloudflare Workers
---

## 環境構築

1. Cloudflare Workersのプロジェクトを作る
   ```sh
   npm create cloudflare@latest example-dart-on-cloudflare
   ```
2. Dartのプロジェクトとしても初期化する
   ```sh
   # すでにNode.jsのプロジェクトとして作っているので`--force`オプションをつける
   dart init --force
   ```
## 動かす

1. Dartのコードを書く
   ```dart
   // bin/main.dart
   import 'dart:js_interop';

   @JS()
   external void responseMessage(JSString message);

   void main(List<String> arguments) {
     final message = 'Hello, Dart!';
     responseMessage(message.toJS);
   }
   ```

2. Wasmにビルドする
   ```sh
   dart compile wasm ./bin/main.dart -o src/__dart/main.wasm
   ```

3. JSのコードを書く(Cloudflare は `import mod from "./module.wasm"`でWasmモジュールを読み込むことができる)．
   ```ts
   // src/index.ts
   import { instantiate, invoke } from "./__dart/index.mjs";
   import mod from "./__dart/index.wasm";

   export default {
     async fetch(
       request: Request,
       env: Env,
       ctx: ExecutionContext,
     ): Promise<Response> {
       let responseMessage: string;
       globalThis.responseMessage = (message: string) => {
         responseMessage = message;
       };

       invoke(
         await instantiate(
           mod,
           async () => ({}),
         ),
       );

       return new Response(responseMessage);
     },
   };
   ```

4. 動かしてみる
   ```sh
   npm run dev
   ```

Deploy先: [example-dart.askua.dev](https://example-dart.askua.dev)

### Import Modules
`WebAssembly.instantiate`を使ってWasmモジュールを読み込むときに，モジュールを渡すことで，Wasmモジュール内で使う関数を定義することができる．

Dartでは，次のように設定することでうまくいく．

```diff
-@JS()
+@pragma("wasm:import", "env.responseMessage")
 external void responseMessage(JSString message);
```

ただ，引数と戻り値は`double`と`JSAny`以外使えないと思った方が良い．
`String`に関してはコンパイルした時にできる `index.mjs`の中にある`stringFromDartString`と`stringToDartString`を良い感じにカスタムすることで使えなくはないが，この辺りのJSの型をDartで良い感じに扱うのであれば`globalThis`に置くのが無難なよう．

下記の書き方は現状推奨しないが，参考実装として置いておく．

```dart
// bin/main.dart
@pragma("wasm:export", "hello")
String hello(String foo) {
  print(foo);
  return 'Hello, Dart!';
}

// mainはビルドに必須
void main(List<String> arguments) {}
```

```ts
// src/index.ts
import { instantiate } from "./__dart/index.mjs";
import { stringFromDartString, stringToDartString } from "./dart_utils.ts";
import mod from "./__dart/index.wasm";

export default {
  async fetch(
    _request: Request,
    _env: Env,
    _ctx: ExecutionContext,
  ): Promise<Response> {
    const dartInstance = await instantiate(mod);
    const message = stringFromDartString(
      dartInstance,
      dartInstance.exports.hello(stringToDartString(dartInstance, "hoge")),
    );

    return new Response(message);
  },
};
```

## 参考

- [Cloudflare Docs / Workers / Quickstarts](https://developers.cloudflare.com/workers/get-started/quickstarts/)
- [Dart / JS types](https://dart.dev/interop/js-interop/js-types)
- [Compiling Dart to WebAssembly (dart2wasm/README.md)](https://github.com/dart-lang/sdk/blob/main/pkg/dart2wasm/README.md)
