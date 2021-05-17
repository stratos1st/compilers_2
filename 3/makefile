all: compile

compile:
	java -jar ./jtb132di.jar -te minijava.jj
	java -jar ./javacc5.jar minijava-jtb.jj
	javac Main.java

# runs all examples and grades them
run:
	make compile
	./script.sh | tee out.txt
	./script1.sh
	rm out.txt

clean:
	rm -f *.class *~ JavaCharStream.java Mini* Token* ParseException.java
	rm -r ./syntaxtree ./visitor
