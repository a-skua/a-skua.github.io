---
layout: layouts/blog.njk
title: ShellScriptとしてRubyを利用する
draft: true
tags:
  - blog
categories:
  - Ruby
  - ShellScript
---

Rubyをよく書くわけではないのですが，個人的に好みの言語の1つです．

最近ShellScriptで全部頑張るよりはRubyをScript言語として使うのが良いのではないか?と思っていたりします．

1. Rubyの中にShellコマンドを組み込みやすいこと．
2. Shellっぽく書くことが可能なこと．
3. オブジェクト指向の言語だということ．

Rubyの中で次のようにbackquoteで囲むとShellコマンドを実行，結果を取得することができます．

```ruby
result = `ls -l`
puts result
```

この程度であればShellScriptでも同様に書くことができます．

```sh
result=$(ls -l)
echo $result
```

しかし，ShellScriptを書く際に条件分岐を多用したり，関数を定義したりしだすと構文周りで面倒なことが出てきたりもします．
_このケースだったら(任意の言語|ShellScript)の方が描きやすいな_
というのはその時々でありますが，Rubyはここの行き来が比較的行いやすい言語だなと感じています．

例えば，現在ブログの移植を進めていたりするのですが，こういったスクリプトを書いたりしています．

```ruby
#!/usr/bin/ruby

`ls blog/`.each_line chomp: true do |line|
  if line =~ /(.*)\.md$/ then
    name = Regexp.last_match 1
    `mkdir blog/#{name}; mv blog/#{name}.md blog/#{name}/index.md` if name != "example"
  end
end
```

これをShellScriptで書くと次のようになります．

```sh
#!/bin/bash

for line in $(ls blog/); do
  if [[ $line =~ (.*)\.md$ ]]; then
    name=${BASH_REMATCH[1]}
    if [ "$name" != "example" ]; then
      mkdir "blog/$name"
      mv "blog/$name.md" "blog/$name/index.md"
    fi
  fi
done
```

このケースなら別にShellScriptでも良いですね．
