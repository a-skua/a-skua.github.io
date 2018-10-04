TESTFILE1 = _posts/1970-01-01-test.md
TESTFILE2 = _posts/1970-01-02-test.md
TESTFILE3 = _posts/1970-01-03-test.md
TESTFILE4 = _posts/1970-01-04-test.md
TESTFILE5 = _posts/1970-01-05-test.md
TESTFILE6 = _posts/1970-01-06-test.md
TESTFILE7 = _posts/1970-01-07-test.md
TESTFILE8 = _posts/1970-01-08-test.md
TESTFILE9 = _posts/1970-01-09-test.md

up:
	jekyll serve

testfile:
	echo '---' >> ${TESTFILE1}
	echo 'layout: post' >> ${TESTFILE1}
	echo 'category: test' >> ${TESTFILE1}
	echo '---' >> ${TESTFILE1}
	echo '# TEST' >> ${TESTFILE1}
	echo 'test  ' >> ${TESTFILE1}
	echo 'test  ' >> ${TESTFILE1}
	echo 'test  ' >> ${TESTFILE1}
	echo 'test  ' >> ${TESTFILE1}
	echo 'test  ' >> ${TESTFILE1}
	echo 'test  ' >> ${TESTFILE1}
	echo 'test  ' >> ${TESTFILE1}
	echo 'test  ' >> ${TESTFILE1}
	echo 'test  ' >> ${TESTFILE1}
	echo 'test  ' >> ${TESTFILE1}
	cp ${TESTFILE1} ${TESTFILE2}
	cp ${TESTFILE1} ${TESTFILE3}
	cp ${TESTFILE1} ${TESTFILE4}
	cp ${TESTFILE1} ${TESTFILE5}
	cp ${TESTFILE1} ${TESTFILE6}
	cp ${TESTFILE1} ${TESTFILE7}
	cp ${TESTFILE1} ${TESTFILE8}
	cp ${TESTFILE1} ${TESTFILE9}
rmtestfile:
	rm ${TESTFILE1}
	rm ${TESTFILE2}
	rm ${TESTFILE3}
	rm ${TESTFILE4}
	rm ${TESTFILE5}
	rm ${TESTFILE6}
	rm ${TESTFILE7}
	rm ${TESTFILE8}
	rm ${TESTFILE9}
retestfile: rmtestfile testfile
