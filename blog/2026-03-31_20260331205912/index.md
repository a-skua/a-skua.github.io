---
layout: layouts/blog.njk
title: (post|pre)installを防ぐためにやっていること
draft: true
tags:
  - blog
---

postinstallの脆弱性の混入問題は去年も騒がれていた記憶があるんですが，「とりあえずやっとくと良いんじゃない?」という設定の覚書．

`deno`使って細かくパーミッション管理しようと言いつつも`npm`を利用する現状で，とりあえず
`.npmrc`に入れている内容:

```ini
save-exact=true
ignore-scripts=true
min-release-age=3
```

## `save-exact`

依存パッケージのバージョンを固定するための設定． `npm i foo`とした時に，
`package.json`のバージョン指定が`"foo": "^1.2.3"`ではなく`"foo": "1.2.3"`になる．

## `ignore-scripts`

`postinstall`や`preinstall`などのスクリプトを無効化するための設定．
`prebuild`なども無効化されるので注意．

## `min-release-age`

新しいバージョンがリリースされてから、インストール可能になるまでの最小期間を指定する設定．
`min-release-age=3`とすると、リリースされてから3日経過しないとインストールできなくなる．
