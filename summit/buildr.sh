#!/bin/sh

export R_VERSION=3.5.2
export MAKE="make -j 20"

#module load gcc/8.1.1
module load gcc/6.4.0
module load essl
#module load bzip2

export LESSL="-L/sw/summit/essl/6.1.0-2/essl/6.1/lib64 -lessl"


check4err(){
  if [ $? -ne 0 ]; then
    >&2 echo "ERROR: couldn't build $1"
    exit 1
  fi
}


# bzip 2
export BZPATH=`pwd`"/bzip2-1.0.6/"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:${BZPATH}"

if [ ! -d "$BZPATH" ]; then
  wget https://sourceforge.net/projects/bzip2/files/latest/download
  tar zxf download
  cd bzip2-1.0.6/
  make
  make install PREFIX=`pwd`
  check4err "bzip2"
  rm -rf download
fi


# R
export CFLAGS="-I${BZPATH}/include -O2"
export CPPFLAGS="-I${BZPATH}/include"
export LDFLAGS="-L${BZPATH}/lib"


if [ ! -d "R-${R_VERSION}" ]; then
  wget https://cran.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz
  
  cd R-${R_VERSION}
  PFX=`pwd`/build
  ./configure --with-x=no --enable-R-shlib=yes --enable-memory-profiling=no --prefix=$PFX --with-blas="${LESSL}" --with-lapack="${LESSL}" \
    && make \
    && make install
  
  check4err "R"
fi
