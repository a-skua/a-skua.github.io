---
layout: layouts/blog.njk
title: javascriptでのDate型の比較
tags:
  - blog
categories:
  - javascript
---

JavascriptにてDate型の比較に失敗した小ネタ。

```javascript
d1 = new Date("1970-01-01T00:00:00");
d2 = new Date("1970-01-01T00:00:00");

while (d1 !== d2) {
  // 何か処理がある
}
```

実際に書いたコードとは少し違うのですが、内容的にはこんな感じの処理を書きました。

結果、めでたく永遠ループに突入しました。

## 解決策

javascriptはオブジェクトが異なると `===` や `==` が `true` にならないって
[こちら](https://qiita.com/labocho/items/5fbaa0491b67221419b4)に書いてありました。

```javascript
d1 = new Date("1970-01-01T00:00:00");
d2 = new Date("1970-01-01T00:00:00");

while (d1.getTime() !== d2.getTime()) {
  // 何か処理が書いてある
}
```

これで解決。
