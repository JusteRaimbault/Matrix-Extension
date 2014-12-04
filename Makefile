ifeq ($(origin JAVA_HOME), undefined)
  ifneq (,$(findstring Darwin,$(shell uname)))
    JAVA_HOME=`/usr/libexec/java_home -F -v1.8*`
  else
    JAVA_HOME=/usr
  endif
endif

ifneq (,$(findstring CYGWIN,$(shell uname -s)))
  COLON=\;
  JAVA_HOME := `cygpath -up "$(JAVA_HOME)"`
else
  COLON=:
endif

ifeq ($(origin SCALA_JAR), undefined)
  SCALA_JAR=$(NETLOGO)/lib/scala-library.jar
endif

SRCS=$(wildcard src/*.java)

matrix.jar: $(SRCS) Jama-1.0.2.jar NetLogoHeadless.jar Makefile manifest.txt
	mkdir -p classes
	$(JAVA_HOME)/bin/javac -g -Werror -encoding us-ascii -source 1.8 -target 1.8 -classpath "NetLogoHeadless.jar$(COLON)Jama-1.0.2.jar$(COLON)$(SCALA_JAR)" -d classes $(SRCS)
	jar cmf manifest.txt matrix.jar -C classes .

NetLogoHeadless.jar:
	curl -f -s -S -L 'http://dl.bintray.com/netlogo/NetLogoHeadlessMaven/org/nlogo/netlogoheadless/5.2.0-841c76b/netlogoheadless-5.2.0-841c76b.jar' -o NetLogoHeadless.jar

Jama-1.0.2.jar:
	curl -f -s -S -L 'http://ccl.northwestern.edu/devel/Jama-1.0.2.jar' -o Jama-1.0.2.jar

matrix.zip: matrix.jar
	rm -rf matrix
	mkdir matrix
	cp -rp matrix.jar Jama-1.0.2.jar README.md Makefile src manifest.txt matrix
	zip -rv matrix.zip matrix
	rm -rf matrix
