testfile:
	echo '---' >> _posts/1970-01-01-test.md
	echo 'layout: post' >> _posts/1970-01-01-test.md
	echo 'category: test' >> _posts/1970-01-01-test.md
	echo '---' >> _posts/1970-01-01-test.md
	echo '# TEST\n' >> _posts/1970-01-01-test.md
	echo 'test\ntest\ntest\ntest\ntest' >> _posts/1970-01-01-test.md
	echo 'test\ntest\ntest\ntest\ntest' >> _posts/1970-01-01-test.md
	echo 'test\ntest\ntest\ntest\ntest' >> _posts/1970-01-01-test.md
	echo 'test\ntest\ntest\ntest\ntest' >> _posts/1970-01-01-test.md
	cp _posts/1970-01-01-test.md _posts/1970-01-02-test.md
	cp _posts/1970-01-01-test.md _posts/1970-01-03-test.md
	cp _posts/1970-01-01-test.md _posts/1970-01-04-test.md
	cp _posts/1970-01-01-test.md _posts/1970-01-05-test.md
	cp _posts/1970-01-01-test.md _posts/1970-01-06-test.md
	cp _posts/1970-01-01-test.md _posts/1970-01-07-test.md
	cp _posts/1970-01-01-test.md _posts/1970-01-08-test.md
	cp _posts/1970-01-01-test.md _posts/1970-01-09-test.md
rmtestfile:
	rm _posts/1970-01-01-test.md
	rm _posts/1970-01-02-test.md
	rm _posts/1970-01-03-test.md
	rm _posts/1970-01-04-test.md
	rm _posts/1970-01-05-test.md
	rm _posts/1970-01-06-test.md
	rm _posts/1970-01-07-test.md
	rm _posts/1970-01-08-test.md
	rm _posts/1970-01-09-test.md

up:
	jekyll serve
