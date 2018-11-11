TESTFILE1 = _posts/1970-01-01-test.md
BEFORE_TESTFILE = _posts/1970-01-0
AFTER_TESTFILE = -test.md

up:
	jekyll serve

testfile:
	echo '---' >> ${TESTFILE1}
	echo 'layout: post' >> ${TESTFILE1}
	echo 'title: "This Is Test Article."' >> ${TESTFILE1}
	echo 'category: test' >> ${TESTFILE1}
	echo '---' >> ${TESTFILE1}
	for i in 0 1 2 3 4 5 6 7 8 9;\
		do\
		echo 'test  ' >> ${TESTFILE1};\
		done
	for i in 2 3 4 5 6 7 8 9;\
		do\
		cp ${TESTFILE1} ${BEFORE_TESTFILE}$$i${AFTER_TESTFILE};\
		done
rmtestfile:
	for i in 1 2 3 4 5 6 7 8 9;\
		do\
		rm ${BEFORE_TESTFILE}$$i${AFTER_TESTFILE};\
		done
retestfile: rmtestfile testfile
