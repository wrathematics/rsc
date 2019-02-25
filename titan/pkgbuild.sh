#!/bin/sh

module load r/3.3.2x
module load PrgEnv-gnu/5.2.82
module load gcc/6.3.0
module swap cray-mpich cray-mpich/7.7.4

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

MPIROOT="/opt/cray/mpt/7.7.4/gni/mpich-cray/8.6/"
LIBTYPE="MPICH2"
CFARGS="--enable-opa=no --with-mpi-include=${MPIROOT}/include --with-mpi-libpath=${MPIROOT}/lib --with-mpi-type=${LIBTYPE}"
cleanPkg src/pbdMPI
R CMD INSTALL src/pbdMPI --no-test-load --configure-args="${CFARGS}"

buildPkg float
buildPkg kazaam
