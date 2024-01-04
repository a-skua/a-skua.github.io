---
layout: layouts/blog.njk
title: Typescriptいおける型が不明な場合の応急処置
tags:
  - blog
categories:
  - vue.js
  - typescript
---

**`vue.js`を`Typescript`を使って書いてみよう！**
と思いたち、Typescriptを書き始めたのですが、 型周りで苦労しているのでメモ。

## 型がわからない問題

`Bootstrap.vue`が便利なので、使っているのですが、
TypeScript側から`Bootstrap.vue`のコンポーネントの型が分からず、
コンパイルエラーで弾かれる事態に…

`Typescript`のメリットである部分が完全に裏目に出てしまったなと。

具体的には`Bootstrap.vue`の`b-modal`なのですが…

```typescript
this.$refs.modal.hide();
```

`hide()`なんて関数は無いよと怒られる状態に陥っていました。

要するに知ってる型にキャスト出来ない問題なのですが、
`vue.js`の型ってどれなんですか…

ただ、現状時間もない状況なので、ひとまずの解決策を置いておきます。

```typescript
let modal: any = this.$refs.modal;
modal.hide();
```

これで、コンパイル時に弾かれなくなりました。

正直無理矢理なので正直なんとも言えない。

## まとめ

今回の件は`Typescript`のメリットである部分が裏目に出てしまったので、

`Typescript`の使いどころを考えないといけないのかなと思える一件でした。

パーツのIOをはっきりさせたりするのは良いのですが、
パーツを呼び出す側はjavascriptで書いた方が幸せになれる気がする…

## 参考

[Bootstrap.vue: b-modal](https://bootstrap-vue.js.org/docs/components/modal/)
