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
else
	mkdir backup
fi

# Example:
#
# fem_loads.c:35:12: note: previous declaration is here
# extern int femFastBC ;
# cp fem_loads.c ./backup/fem_loads.c
# sed -i '35,35 s/^/\/\//' fem_loads.c
# perl -ne'30..40 and print' fem_loads.c


echo "-------------------------------"
# fem_para.c:39:13: error: redeclaration of 'femFastBC' with a different type: 'long' vs 'int'
# extern long femFastBC ; /* "fast" work with boundary conditions */
cp fem_para.c       ./backup/fem_para.c
sed -i '39,39 s/long/int/'   fem_para.c
perl -ne'30..40 and print'   fem_para.c


echo "-------------------------------"
# fem_sol.c:33:6: error: redefinition of 'femFastBC' with a different type: 'long' vs 'int'
# long femFastBC = 0 ; /* "fast" work with boundary conditions */
cp fem_sol.c        ./backup/fem_sol.c
sed -i '33,33 s/long/int/'   fem_sol.c
perl -ne'30..40 and print'   fem_sol.c

echo "-------------------------------"
cp fem_chen.c       ./backup/fem_chen.c
sed -i 's/chen_limit_test/chen_limit_test2/'   fem_chen.c
perl -ne'250..260 and print'   fem_chen.c
perl -ne'540..550 and print'   fem_chen.c



echo "-------------------------------"
echo "used includes"
cat *.h *.c | ack ifdef | sort | uniq

echo "-------------------------------"
echo "Transpilation"
c4go transpile -clang-flag="-DDEVEL -DDEVEL_VERBOSE -DRUN_VERBOSE -D_MATRIX_SAVING_" -o fem.go *.h fem*.c
mv fem.go ../../fem.go


# c4go transpile -clang-flag="-DDEVEL -DDEVEL_VERBOSE -DRUN_VERBOSE -D_MATRIX_SAVING_" -o math_mviz.go math_mviz.c
# mv math_mviz.go ../../math_mviz.go



cp -f ./backup/* .



cd ../..

go run fem.go
