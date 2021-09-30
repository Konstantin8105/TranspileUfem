#!/bin/bash
if [ -d "ufem" ] 
then
    echo "Directory ufem exists." 
else
	git clone https://github.com/jurabr/ufem.git
fi

# enter to ufem
cd ufem/fem

echo "clean and show files"
make clean; ls

echo "backup"
if [ -d "backup" ] 
then
    echo "Directory ufem exists."
	cp -f ./backup/* .
else
	mkdir backup
fi



echo "used includes"
cat *.h *.c | ack ifdef | sort | uniq

echo "Transpilation"
c4go transpile -clang-flag="-DDEVEL -DDEVEL_VERBOSE -DRUN_VERBOSE -D_MATRIX_SAVING_" -o ../../fem.go *.h fem*.c

cd ../..
