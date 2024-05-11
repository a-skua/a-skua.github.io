#!/usr/bin/env ruby

new_dir = "blog/#{Time.new.strftime '%Y-%m-%d_%Y%m%d%H%M%S'}"

content = <<EOS
---
layout: layouts/blog.njk
title: New Article
draft: true
tags:
  - blog
---
EOS

`mkdir #{new_dir}; echo '#{content}' > #{new_dir}/index.md`
