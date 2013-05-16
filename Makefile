ifeq ($(origin JAVA_HOME), undefined)
  JAVA_HOME=/usr
endif

ifneq (,$(findstring CYGWIN,$(shell uname -s)))
  COLON=\;
  JAVA_HOME := `cygpath -up "$(JAVA_HOME)"`
else
  COLON=:
endif

SRCS=$(wildcard src/*.java)

matrix.jar: $(SRCS) Jama-1.0.2.jar NetLogoHeadless.jar Makefile manifest.txt
	mkdir -p classes
	$(JAVA_HOME)/bin/javac -g -encoding us-ascii -source 1.7 -target 1.7 -classpath NetLogoHeadless.jar$(COLON)Jama-1.0.2.jar$(COLON)$(HOME)/.sbt/boot/scala-2.10.1/lib/scala-library.jar -d classes $(SRCS)
	jar cmf manifest.txt matrix.jar -C classes .

NetLogoHeadless.jar:
	curl -f -s -S 'http://ccl.northwestern.edu/devel/NetLogoHeadless-e2bba9de.jar' -o NetLogoHeadless.jar

Jama-1.0.2.jar:
	curl -f -s -S 'http://ccl.northwestern.edu/devel/Jama-1.0.2.jar' -o Jama-1.0.2.jar

matrix.zip: matrix.jar
	rm -rf matrix
	mkdir matrix
	cp -rp matrix.jar Jama-1.0.2.jar README.md Makefile src manifest.txt matrix
	zip -rv matrix.zip matrix
	rm -rf matrix
