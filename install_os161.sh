#!/bin/sh

cd os161/scratch

#GMP
cd gmp-4.3.2
./configure --disable-shared --enable-static --prefix=$HOME/os161/tools
sudo make -j 8
sudo make install
cd ..

#MPFR
cd mpfr-2.4.2
./configure --disable-shared --enable-static --prefix=$HOME/os161/tools --with-gmp=$HOME/os161/tools
sudo make -j 8
sudo make install
cd ..

#MPC
cd mpc-0.8.1
./configure --disable-shared --enable-static --prefix=$HOME/os161/tools \
			--with-gmp=$HOME/os161/tools \
			--with-mpfr=$HOME/os161/tools
sudo make -j 8
sudo make install
cd ..

#ISL
#cd isl-0.11.1
#./configure --prefix=$HOME/os161/tools --with-gmp-prefix=$HOME/os161/tools
#sudo make -j 8
#sudo make install
#cd ..

#CLOOG
#cd cloog-0.18.0
#./configure --prefix=$HOME/os161/tools --with-gmp-prefix=$HOME/os161/tools --with-isl-prefix=$HOME/os161/tools
#sudo make -j 8
#sudo make install
#cd ..


#OS161 - START TOOLCHAIN
#BINUTILS
cd binutils-2.24+os161-2.1
find . -name '*.info' | xargs touch
touch intl/plural.c
./configure --nfp --disable-werror --target=mips-harvard-os161 --prefix=$HOME/os161/tools
sudo make -j 8
sudo make install
cd ..

#GCC
cd gcc-4.8.3+os161-2.1
find . -name '*.info' | xargs touch
touch intl/plural.c
cd ..
mkdir buildgcc
cd buildgcc
../gcc-4.8.3+os161-2.1/configure \
		--enable-languages=c,lto \
		--nfp --disable-shared --disable-threads \
		--disable-libmudflap --disable-libssp \
		--disable-libstdcxx --disable-nls \
		--target=mips-harvard-os161 \
		--prefix=$HOME/os161/tools \
		--with-gmp=$HOME/os161/tools \
		--with-mpfr=$HOME/os161/tools \
		--with-mpc=$HOME/os161/tools #\
#		--with-isl=$HOME/os161/tools #\
		#--with-cloog=$HOME/os161/tools
sudo make -j 8
sudo make install
cd ..

#GDB - IF PROBLEMS CHECKOUT https://stackoom.com/question/3dvLj/使用os-mips编译的gdb-的链接错误
cd gdb-7.8+os161-2.1
./configure --target=mips-harvard-os161 \
			--disable-shared --enable-static \
			--prefix=$HOME/os161/tools \
			--with-isl=$HOME/os161/tools
sudo make -j 8
sudo make install
cd ..

#SYS161
cd sys161-2.0.2
./configure --prefix=$HOME/os161/tools mipseb
sudo make -j 8
sudo make install
cd ..

#BMAKE
cd bmake
./configure --prefix=$HOME/os161/tools --with-default-sys-path=$HOME/os161/tools/share/mk
sh ./make-bootstrap.sh
mkdir -p $HOME/os161/tools/bin
mkdir -p $HOME/os161/tools/share/man/man1
mkdir -p $HOME/os161/tools/share/mk
cp bmake $HOME/os161/tools/bin/
cp bmake.1 $HOME/os161/tools/share/man/man1/
sh mk/install-mk $HOME/os161/tools/share/mk
cd ..



#FINISH
cd ~/os161/tools
sh -c 'for i in mips-*; do ln -s $i os161-`echo $i | cut -d- -f4-`; done'
   
# add path permanently
#echo "export PATH=~/os161/tools/bin:$PATH" >> ~/.bash_profile
   
   
   
