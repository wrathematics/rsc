#!/bin/sh

#module load gcc/8.1.1
module load gcc/6.4.0
module load cuda/9.2.148

export R_VERSION=3.5.2
export MAKE="make -j 20"
export R_LIBS=`pwd`/lib

cleanPkg(){
  pushd .
  cd src/$1
  ./cleanup
  popd
}

buildPkg(){
  cleanPkg $1
  ./R-${R_VERSION}/bin/R CMD INSTALL src/$1 --no-test-load
}

buildPkg float
buildPkg pbdMPI
buildPkg kazaam

cleanPkg curand
./R-3.5.2/bin/R CMD INSTALL src/curand/ --configure-args="--with-cuda=/sw/summit/cuda/9.2.148/" --no-test-load

cleanPkg glmrgame
jsrun -n1 ./R-3.5.2/bin/R CMD INSTALL src/glmrgame/ --configure-args="--with-cuda=/sw/summit/cuda/9.2.148/" --no-test-load
