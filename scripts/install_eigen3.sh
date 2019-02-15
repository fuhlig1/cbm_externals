#!/bin/bash


if [ ! -d  $SIMPATH/alignment/eigen3 ];
then
  cd $SIMPATH/alignment
  if [ ! -e $EIGEN3_VERSION.tar.bz2 ];
  then
    echo "*** Downloading eigen3 sources ***"
    download_file $EIGEN3_LOCATION/$EIGEN3_VERSION.tar.bz2
  fi
  untar eigen3 $EIGEN3_VERSION.tar.bz2
  mv eigen-* eigen3
  cd $SIMPATH
fi

install_prefix=$SIMPATH_INSTALL

checkfile=$install_prefix/include/eigen3

if (not_there Eigen3 $checkfile);
then
    cd $SIMPATH/alignment/eigen3
    mkdir build
    cd build
    cmake -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL \
          ..
          
    make install
          
    check_success Eigen3 $checkfile
    check=$?

fi

cd $SIMPATH

return 1
