#!/bin/bash

# Define the main source directory
export source_dir=$PWD

# Define the versions of packages to be build
source scripts/package_versions.sh

# Get FairSoft to have all scripts available
if [ ! -d fairsoft ];then
  git clone $FAIRSOFT_LOCATION fairsoft
  cd fairsoft
  git checkout -b tag_$FAIRSOFT_VERSION $FAIRSOFT_VERSION
  cd $source_dir
fi

# Check if we build on Linux or Mac OSX
bla=sw_vers
if [ "0" == "$?" ]; then
  os=macosx
  compiler=Clang
else
  os=linux
  compiler=gcc
fi

echo "OS: $os"
echo "Compiler: $compiler"   
