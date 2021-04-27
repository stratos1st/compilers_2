all: compile

compile:
	java -jar ./jtb132di.jar -te minijava.jj
	java -jar ./javacc5.jar minijava-jtb.jj
	javac Main.java

# bgazi apla an metaglotistike to programma i oxi
run_: # an balo se comments kapia line tis main pou sxetizonte me to print_offsets doulebi
	make compile
	java Main ./minijava-examples-new/*.java > exit.txt 2> err.txt
	java Main ./minijava-examples-new/minijava-extra/*.java >> exit.txt 2>>err.txt
	java Main ./minijava-examples-new/minijava-error-extra/*.java >> exit.txt 2>> err.txt
	java Main ./minijava-examples-new/bazio/*.java >> exit.txt 2>> err.txt
	echo "----- False possitives-------------------------------" > wrong.txt
	sed '/error/!d' exit.txt >> wrong.txt
	rm exit.txt
	echo "\n\n----- False negatives-------------------------------" >> wrong.txt
	./script.sh >> wrong.txt
	rm err.txt
	awk '/^~/{a++}END{print a}' wrong.txt | cat - wrong.txt > temp && mv temp wrong.txt
	awk '/^\.\//{a++}END{print a}' wrong.txt | cat - wrong.txt > temp && mv temp wrong.txt

run_offsets:# prepi na iparxoun idi i fakeli gia na bali ta arxia!!
	make compile
	java Main ./minijava-examples-new/*.java > outs.out 2>/dev/null
	java Main ./minijava-examples-new/minijava-extra/*.java >> outs.out 2>/dev/null
	java Main ./minijava-examples-new/bazio/*.java >> outs.out 2>/dev/null
	./script1.sh
	rm outs.out
	rm -r ./my_offsets/minijava-examples-new/*.txt
	rm -r ./my_offsets/minijava-examples-new/minijava-extra/*.txt
	rm -r ./my_offsets/minijava-examples-new/bazio/*.out
	rename 's/\.java/\.txt/' ./my_offsets/minijava-examples-new/*.java
	rename 's/\.java/\.txt/' ./my_offsets/minijava-examples-new/minijava-extra/*.java
	rename 's/\.java/\.out/' ./my_offsets/minijava-examples-new/bazio/*.java

clean:
	rm -f *.class *~ JavaCharStream.java Mini* Token* ParseException.java
	rm -r ./syntaxtree ./visitor
