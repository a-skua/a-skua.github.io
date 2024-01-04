---
layout: layouts/blog.njk
title: クリックして100万円当てよう! -XSS対策-
tags:
  - blog
categories:
  - javascript
  - xss
---

## 前置き

`クリックして100万円当てよう!`というタイトルにしようとしてたんですが、
なんだか詐欺っぽいので `-XSS対策-`を付けました (詐欺の話です)。\
正直、
`XSS`対策なんてものは多くの人が書いているので基本的にはそっちを見てもらえば良いのですが、個人的に面白いパターンを見つけたので残して起きます。

## 内容

1. メタ文字エスケープしているだけで安心してはならない
1. 対策とその責任の在処

## メタ文字エスケープしているだけで安心してはならない

ユーザーがコメント入力フォームに下記のように入力しました。

```html
<button onclick="alert('応募料金として10万円かかります。');">クリックして100万円当てよう!</button>
```

これをXSS対策として、次のようにエスケープしてコメント一覧に表示しました。

```text
&lt;button onclick=&quot;alert('応募料金として10万円かかります。');&quot;&gt;クリックして100万円当てよう!&lt;/button&gt;
```

これはもちろん正しいです。
例としては簡単なものですが、XSS対策の基本としてよく取り上げられる内容ですでに見ている人は知っているかと思います。

では何が問題になるのかというと、これをJavaScriptで取り扱うときにちゃんと注意して取り扱わないとXSSを発動させてしまうという話をします。

### 問題となる例

```html
<p id="message">
&lt;button onclick=&quot;alert('応募料金として10万円かかります。');&quot;&gt;クリックして100万円当てよう!&lt;/button&gt;
</p>
<script>
const messageElement = document.getElementById('message');
console.log(messageElement.textContent);
</script>
```

上記の例で
`console.log(msssageElement.textContent);`はどう表示されるでしょうか...?\
`&lt;button onclick=&quot;alert('応募料金として10万円かかります。');&quot;&gt;クリックして100万円当てよう!&lt;/button&gt;`ではなく、
`<button onclick="alert('応募料金として10万円かかります。');">クリックして100万円当てよう!</button>`と表示されます。\
この文字列の扱いを間違ってしまうとXSSを発動させてしまうことになります...

```html
<p id="message">
&lt;button onclick=&quot;alert('応募料金として10万円かかります。');&quot;&gt;クリックして100万円当てよう!&lt;/button&gt;
</p>

<p id="innter-html"></p>
<p id="text-content"></p>

<script>
const messageElement = document.getElementById('message');

const innerHTMLElement = document.getElementById('inner-html');
const textContentElement = document.getElementById('text-content');

innerHTMLElement.innerHTNL = messageElement.textContent;
textContentElement.textContent = messageElement.textContent;
</script>
```

この例では、`id="innter-html"`には、見事にbuttonが表示されてしまいます。

## 対策とその責任の在処

対策として出来ることは何かという話なんですが、
JavaScriptとして文字列を扱うときに `HTML`として扱うな。 これに尽きると思います。

### よくある間違い

メタ文字エスケープなんですが、
これはHTMLにおける話であって、JavaScriptの話ではない。\
どういうことかというと、ここでとりあげている過ちは至るところにあると思います。

```html
<p id="message"></p>

<script>
const messageElement = document.getElementById('message');

messageElement.innerHTML = '&lt;button onclick=&quot;alert(\'応募料金として10万円かかります。\');&quot;&gt;クリックして100万円当てよう!&lt;/button&gt;';
</script>
```

上記の例はアンチパターンとして捉えて貰って良いと思います。
**HTMLに対してメタ文字エスケープをするべきですが、JavaScriptに対してHTMLと同様のメタ文字エスケープをするべきではない。**

```html
<p id="message"></p>

<script>
const messageElement = document.getElementById('message');

messageElement.textContent = '<button onclick="alert(\'応募料金として10万円かかります。\');">クリックして100万円当てよう!</button>';
</script>
```

JavaScriptで文字列を扱うときはHTMLとして扱わず、文字列として扱いましょう。
自分はちゃんと使い分けられるから大丈夫だ、といった人の善意に頼った実装は辞めましょう。
(そんなものがあれば脆弱性なんか生まれないので)

HTML側のメタ文字エスケープに関する責任はHTMLの責任であってJavaScript側の責任ではないということ、
JavaScript側で文字列をHTMLとして扱わないというのはJavaScript側の責任であるということ。
この2つを切り分けて考えるべきです。

### JSON API

これの一環の話になりますが、 JSON APIを実装している場合、
APIで返す文字列は当然HTMLメタ文字エスケープをするべきではないです。
APIからメタ文字エスケープされて帰ってきているから泣く泣く
`innerHTML`を使っている、なんてのは脆弱性が生まれる原因となります。
HTMLを返す場合は、当然メタ文字エスケープをするべきですが、JSONを返す場合にそのようなことをするのはアンチパターンとして扱っていいでしょう。
JSON
APIの責任はあくまでJavaScriptに限定されるべきであってHTMLの表示にまで責任の裾野を広げるべきではないでしょう(これは表示するときのJavaScript側の責任になります)。
