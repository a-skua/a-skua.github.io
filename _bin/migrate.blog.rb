#!/usr/bin/ruby

# データ移行用スクリプト

`ls blog/`.each_line chomp: true do |line|
  if line =~ /(.*)\.md$/ then
    name = Regexp.last_match 1
    `mkdir blog/#{name}; mv blog/#{name}.md blog/#{name}/index.md` if name != "example"
  end
end
