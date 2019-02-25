#!/bin/sh

module load r/3.4.2
module load PE-gnu/6.2.0-2.0.1
module load gcc/6.2.0

export MAKE="make -j 16"
export R_LIBS=`pwd`/lib

cleanPkg(){
  pushd .
  cd $1
  ./cleanup
  popd
}

buildPkg(){
  cleanPkg $1
  R CMD INSTALL $1 --no-test-load
}


buildPkg pbdMPI

buildPkg float
buildPkg kazaam
