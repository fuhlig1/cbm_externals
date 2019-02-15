#!/bin/bash


if [ ! -d  $SIMPATH/alignment/GBL ];
then
  cd $SIMPATH/alignment
  if [ ! -d GBL ];
  then
    echo "*** Downloading GBL sources with subversion***"
    svn co $GBL_LOCATION/$GBL_VERSION GBL
  fi
fi

install_prefix=$SIMPATH_INSTALL
checkfile=$install_prefix/bin/GBLpp

if (not_there GBL $checkfile);
then

  cd $SIMPATH/alignment/GBL/cpp
  mkdir build
  cd build
    
  $SIMPATH_INSTALL/bin/cmake \
        -DEIGEN3_INCLUDE_DIR=$SIMPATH_INSTALL/include/eigen3 \
        -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL \
        -DCMAKE_CXX_COMPILER=$CXX \
        -DCMAKE_C_COMPILER=$CC \
        ..

  make -j$number_of_processes
  make install
  
  check_success GBL $checkfile
  check=$?

fi

if [ "$platform" = "macosx" ];
then
  export DYLD_LIBRARY_PATH=$DYLD_LIBRARY_PATH:$install_prefix
else
  export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$SIMPATH/install_prefix
fi

cd $SIMPATH

return 1
