.PHONY: serve
serve:
	deno task serve

.PHONY: new
new:
	./_bin/new_article.rb

# TODO
.PHONY: convert
convert:
	magick mogrify -verbose -strip -resize 800x800\> -quality 90 -define png:color-type=2 *.png
