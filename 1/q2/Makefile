compile:
	jflex scanner.flex
	java -jar ./java-cup-11b.jar -interface -parser Parser parser.cup
	javac -cp ./java-cup-11b-runtime.jar *.java

execute:
	java -cp ./java-cup-11b-runtime.jar:. Main > ./results/Main.java

test:
	jflex scanner.flex
	java -jar ./java-cup-11b.jar -interface -parser Parser parser.cup
	javac -cp ./java-cup-11b-runtime.jar *.java
	for i in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16; do echo testing test$$i.txt; java -cp ./java-cup-11b-runtime.jar:. Main > ./results/Main.java < ./tests/test$$i.txt; javac ./results/Main.java; done

clean:
	rm -f *.class *~ Parser.java Scanner.java sym.java
