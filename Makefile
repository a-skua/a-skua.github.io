.PHONY: up
up:
	deno task serve

.PHONY: new
new:
	touch _posts/$(shell date +%Y-%m-%d)-$(shell read -p "Title: " title; echo $$title | sed -e 's/ /-/g' | tr '[:upper:]' '[:lower:]').md

.PHONY: convert
convert:
	magick mogrify -verbose -strip -resize 800x800\> -quality 90 -define png:color-type=2 *.png
