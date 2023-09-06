#!/usr/bin/ruby

# データ移行用スクリプト

# blog/以下の(.*).mdファイルをblog/(.*)/index.mdに移動
`ls blog/`.each_line chomp: true do |line|
  if line =~ /(.*)\.md$/ then
    name = Regexp.last_match 1
    `mkdir blog/#{name}; mv blog/#{name}.md blog/#{name}/index.md` if name != "example"
  end
end

# blog/以下のディレクトリ名称をyyyy-mm-dd_yyyymmddhhmmssに変更
date_count = {}
`ls blog/`.each_line chomp: true do |line|
  if line =~ /(\d{4})-(\d{2})-(\d{2})_.*/ then
    old_dir = Regexp.last_match 0
    year = Regexp.last_match 1
    month = Regexp.last_match 2
    day = Regexp.last_match 3

    key = "#{year}-#{month}-#{day}"
    if date_count.key? key then
      date_count[key] += 1
    else
      date_count[key] = 1
    end

    new_dir = "#{year}-#{month}-#{day}_#{year}#{month}#{day}#{format '%06d', date_count[key]}"
    `mv blog/#{old_dir} blog/#{new_dir}`
  end
end
