#!/bin/bash

#compiles all tests and runs them and compares them with correct rusults

for f in ./minijava-examples-new/*.java; do
  filename="${f##*/}"
  filename="${filename%.*}"
  java Main $f &> ./my_ans/minijava-examples-new/${filename}.ll
  lli ./my_ans/minijava-examples-new/${filename}.ll &> ./my_ans/minijava-examples-new/${filename}.out
  echo "--------------------- " ${filename}.out " ----------------"
  diff -y --suppress-common-lines -W 100 ./my_ans/minijava-examples-new/${filename}.out ./correct_ans/minijava-examples-new/${filename}.out
done

echo "===================== " /minijava-extra " ================"

for f in ./minijava-examples-new/minijava-extra/*.java; do
  filename="${f##*/}"
  filename="${filename%.*}"
  java Main $f &> ./my_ans/minijava-examples-new/minijava-extra/${filename}.ll
  lli ./my_ans/minijava-examples-new/minijava-extra/${filename}.ll &> ./my_ans/minijava-examples-new/minijava-extra/${filename}.out
  echo "--------------------- " ${filename}.out " ----------------"
  diff -y --suppress-common-lines -W 100 ./my_ans/minijava-examples-new/minijava-extra/${filename}.out ./correct_ans/minijava-examples-new/minijava-extra/${filename}.out
done

echo "===================== " /codegen " ================"

for f in ./minijava-examples-new/codegen/*.java; do
  filename="${f##*/}"
  filename="${filename%.*}"
  java Main $f &> ./my_ans/minijava-examples-new/codegen/${filename}.ll
  lli ./my_ans/minijava-examples-new/codegen/${filename}.ll &> ./my_ans/minijava-examples-new/codegen/${filename}.out
  echo "--------------------- " ${filename}.out " ----------------"
  diff -y --suppress-common-lines -W 100 ./my_ans/minijava-examples-new/codegen/${filename}.out ./correct_ans/minijava-examples-new/codegen/${filename}.out
done

echo "-"

exit 0
