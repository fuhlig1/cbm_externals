#!/bin/bash

if [ ! -d  $SIMPATH/basics/cpprestsdk ]; then
  cd $SIMPATH/basics
  git clone $CPPRESTSDK_LOCATION

  cd $SIMPATH/basics/cpprestsdk
  git checkout -b tag_$CPPRESTSDK_TAG $CPPRESTSDK_TAG
  git submodule update --init
fi

install_prefix=$SIMPATH_INSTALL

checkfile=$install_prefix/include/cpprest/containerstream.h

if (not_there CppRestSdk $checkfile);
then
    cd $SIMPATH/basics/cpprestsdk
    mkdir build
    cd build   
    cmake -DCMAKE_C_COMPILER=$CC         \
          -DCMAKE_CXX_COMPILER=$CXX      \
          -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
          -DCMAKE_INSTALL_PREFIX=$SIMPATH_INSTALL \
          -DBoost_NO_SYSTEM_PATHS=TRUE \
          -DBoost_NO_BOOST_CMAKE=TRUE \
          -DBOOST_ROOT=$SIMPATH_INSTALL \
          -DWERROR=OFF \
          ..

    make -j$number_of_processes
    make install

    check_all_libraries  $install_prefix/lib

    check_success CppRestSdk $checkfile
    check=$?

fi

cd $SIMPATH

return 1
