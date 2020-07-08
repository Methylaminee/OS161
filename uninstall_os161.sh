#!/bin/sh
cd ~/OS161/scratch

rm -r binutils-2.24+os161-2.1
rm -r gcc-4.8.3+os161-2.1
rm -r gdb-7.8+os161-2.1
rm -r sys161-2.0.2
rm -r bmake
rm -r gmp-4.3.2
rm -r mpfr-2.4.2
rm -r mpc-0.8.1
rm -r isl-0.11.1
rm -r cloog-0.18.0
rm -r buildgcc

if [$1 == "--all"]
 then
    printf $1
    printf "\nI'll remove all."
    #cd ..
    #rm -r tools/
    #rm -r toolbuild/
fi
