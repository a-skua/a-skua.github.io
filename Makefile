PORT ?= 3000

.PHONY: serve
serve:
	PORT=$(PORT) docker compose up

.PHONY: down
down:
	docker compose down

.PHONY: build
build:
	docker compose run --rm deno task lume

.PHONY: new
new:
	./_bin/new_article.rb

# TODO
.PHONY: convert
convert:
	magick mogrify -verbose -strip -resize 800x800\> -quality 90 -define png:color-type=2 *.png
