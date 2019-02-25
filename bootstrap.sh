#!/bin/sh

MACHINES=`find -maxdepth 1 -mindepth 1 -type d`

HN=`echo $HOSTNAME | sed -e 's/-.*//'`

for m in $MACHINES; do
  if [ X${HN} = X${m} ]; then
    mv ${m}/* .
    touch .found_machine
  fi
done

if [ ! -f .found_machine ]; then
  >&2 echo "ERROR: couldn't find machine configuration"
  exit 1
fi

mkdir -p ./lib
mkdir -p ./src

cd src
git clone https://github.com/wrathematics/float
git clone https://github.com/wrathematics/curand
git clone https://github.com/snoweye/pbdMPI
git clone https://github.com/rbigdata/kazaam
git clone https://github.com/rbigdata/glmrgame
cd ..

cat ".libPaths(paste0(getwd(), '/lib'))" > .Rprofile

for m in $MACHINES; do
  rm -rf $m
done
rm .found_machine
rm -f README.md
rm -rf .git*
rm bootstrap.sh
