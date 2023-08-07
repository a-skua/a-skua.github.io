.PHONY: up
up:
	bundle exec jekyll serve

.PHONY: new
new:
	touch _posts/$(shell date +%Y-%m-%d)-$(shell read -p "Title: " title; echo $$title | sed -e 's/ /-/g' | tr '[:upper:]' '[:lower:]').md
