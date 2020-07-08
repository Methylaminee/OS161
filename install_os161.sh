#!/bin/sh

set -e
# create build directories
mkdir -p ~/OS161
mkdir -p ~/OS161/toolbuild
mkdir -p ~/OS161/tools
mkdir -p ~/OS161/tools/bin
mkdir -p ~/OS161/scratch

# add tools/bin to path 
export PATH=~/os161/tools/bin:$PATH


# download source
cd ~/OS161/scratch
#wget http://os161.eecs.harvard.edu/download/binutils-2.24+os161-2.1.tar.gz
#wget http://os161.eecs.harvard.edu/download/gcc-4.8.3+os161-2.1.tar.gz
#wget http://os161.eecs.harvard.edu/download/gdb-7.8+os161-2.1.tar.gz
#wget http://os161.eecs.harvard.edu/download/bmake-20101215.tar.gz
#wget http://os161.eecs.harvard.edu/download/mk-20100612.tar.gz
#wget http://os161.eecs.harvard.edu/download/sys161-2.0.2.tar.gz
#wget https://ftp.gnu.org/gnu/gmp/gmp-4.3.2.tar.gz
#wget https://ftp.gnu.org/gnu/mpfr/mpfr-2.4.2.tar.gz
#wget https://gcc.gnu.org/pub/gcc/infrastructure/mpc-0.8.1.tar.gz
#wget https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.11.1.tar.bz2
#wget https://gcc.gnu.org/pub/gcc/infrastructure/cloog-0.18.0.tar.gz

#untar
cd ~/OS161/scratch
tar -xvzf binutils-2.24+os161-2.1.tar.gz
tar -xvzf gcc-4.8.3+os161-2.1.tar.gz
tar -xvzf gdb-7.8+os161-2.1.tar.gz
tar -xvzf sys161-2.0.2.tar.gz
tar -xvzf bmake-20101215.tar.gz
cd bmake
tar -xvzf ../mk-20100612.tar.gz
cd ..
tar -xvzf gmp-4.3.2.tar.gz
tar -xvzf mpfr-2.4.2.tar.gz
tar -xvzf mpc-0.8.1.tar.gz
#tar -xjvf isl-0.11.1.tar.bz2
#tar -xvzf cloog-0.18.0.tar.gz


#START INSTALL
echo ">>>>>>>>>>>>>>>>>>>START INSTALLATION<<<<<<<<<<<<<<<<<<<"
cd ~/OS161/scratch

#GMP
echo ">>>>>>>>>>>>>>>>>>>START GMP<<<<<<<<<<<<<<<<<<<"
cd gmp-4.3.2
./configure --disable-shared --enable-static --prefix=$HOME/OS161/tools
sudo make -j 8
sudo make install
cd ..

#MPFR
echo ">>>>>>>>>>>>>>>>>>>START MPFR<<<<<<<<<<<<<<<<<<<"
cd mpfr-2.4.2
./configure --disable-shared --enable-static --prefix=$HOME/OS161/tools --with-gmp=$HOME/OS161/tools
sudo make -j 8
sudo make install
cd ..

#MPC
echo ">>>>>>>>>>>>>>>>>>>START MPC<<<<<<<<<<<<<<<<<<<"
cd mpc-0.8.1
./configure --disable-shared --enable-static --prefix=$HOME/OS161/tools \
			--with-gmp=$HOME/OS161/tools \
			--with-mpfr=$HOME/OS161/tools
sudo make -j 8
sudo make install
cd ..

#ISL
#echo ">>>>>>>>>>>>>>>>>>>START ISL<<<<<<<<<<<<<<<<<<<"
#cd isl-0.11.1
#./configure --prefix=$HOME/OS161/tools --disable-shared --enable-static \
#			--with-gmp-prefix=$HOME/OS161/tools
#sudo make -j 8
#sudo make install
#cd ..

#CLOOG
#echo ">>>>>>>>>>>>>>>>>>>START CLOOG<<<<<<<<<<<<<<<<<<<"
#cd cloog-0.18.0
#./configure --prefix=$HOME/OS161/tools --disable-shared --enable-static \
#			--with-gmp-prefix=$HOME/OS161/tools \
#			--with-isl-prefix=$HOME/OS161/tools
#sudo make -j 8
#sudo make install
#cd ..


#OS161 - START TOOLCHAIN
#BINUTILS
echo ">>>>>>>>>>>>>>>>>>>START BINUTILS<<<<<<<<<<<<<<<<<<<"
cd binutils-2.24+os161-2.1
find . -name '*.info' | xargs touch
touch intl/plural.c
./configure --nfp --disable-werror --target=mips-harvard-os161 --prefix=$HOME/OS161/tools
sudo make -j 8
sudo make install
cd ..

#GCC
echo ">>>>>>>>>>>>>>>>>>>START GCC<<<<<<<<<<<<<<<<<<<"
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
		--prefix=$HOME/OS161/tools \
		--with-gmp=$HOME/OS161/tools \
		--with-mpfr=$HOME/OS161/tools \
		--with-mpc=$HOME/OS161/tools #\
#		--with-isl=$HOME/OS161/tools #\
		#--with-cloog=$HOME/OS161/tools
sudo make -j 8
sudo make install
cd ..

#GDB - IF PROBLEMS CHECKOUT https://stackoom.com/question/3dvLj/使用os-mips编译的gdb-的链接错误
echo ">>>>>>>>>>>>>>>>>>>START GDB<<<<<<<<<<<<<<<<<<<"
cd gdb-7.8+os161-2.1
./configure --target=mips-harvard-os161 \
			--disable-shared --enable-static \
			--prefix=$HOME/OS161/tools \
#			--with-isl=$HOME/OS161/tools
sudo make -j 8
sudo make install
cd ..

#SYS161
echo ">>>>>>>>>>>>>>>>>>>START SYS161<<<<<<<<<<<<<<<<<<<"
cd sys161-2.0.2
./configure --prefix=$HOME/OS161/tools mipseb
sudo make -j 8
sudo make install
cd ..

#BMAKE
echo ">>>>>>>>>>>>>>>>>>>START BMAKE<<<<<<<<<<<<<<<<<<<"
cd bmake
./configure --prefix=$HOME/OS161/tools --with-default-sys-path=$HOME/OS161/tools/share/mk
sh ./make-bootstrap.sh
mkdir -p $HOME/OS161/tools/bin
mkdir -p $HOME/OS161/tools/share/man/man1
mkdir -p $HOME/OS161/tools/share/mk
cp bmake $HOME/OS161/tools/bin/
cp bmake.1 $HOME/OS161/tools/share/man/man1/
sh mk/install-mk $HOME/OS161/tools/share/mk
cd ..



#FINISH
cd ~/OS161/tools
sh -c 'for i in mips-*; do ln -s $i os161-`echo $i | cut -d- -f4-`; done'

# add path permanently
echo "export PATH=~/OS161/tools/bin:~OS161/tools/sys161/bin:$PATH" >> ~/.bash_profile
