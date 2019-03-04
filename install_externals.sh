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
#bla=sw_vers
#if [ "0" == "$?" ]; then
#  os=macosx
#  compiler=Clang
#else
#  os=linux
#  compiler=gcc
#fi

#echo "OS: $os"
#echo "Compiler: $compiler"   

if [ ! -e fairsoft_install_ok ];then
  # If the file automatic.conf exist use the file for the
  # Fairsoft installation, otherwise use the menu
  if [ -e automatic.conf ]; then
    echo "Found file automatic.conf which is used for non menu based installation of FairSoft"
    echo "The follwing output will come from the FairSoft installation." 
    cp automatic.conf fairsoft
    cd fairsoft
    ./configure.sh automatic.conf
    retVal=$?
  else 
    echo "Use menu based installation of FairSoft"
    echo "The follwing output will come from the FairSoft installation." 
    cd fairsoft
    ./configure.sh
    retVal=$?
  fi
  
  if [ "$retVal" == "0" ]; then
    check=1
    echo "FairSoft succesfully compiled" >> $source_dir/fairsoft_install_ok
  else
    check=0
  fi  
else
  check=1
fi

# Go back inmain source directory
cd $source_dir

# After the previous step FairSoft should be installed
# For the further processing will will use the cached
# values from the fairsoft installation and the functions
# already used for the FairSoft installation
source fairsoft/scripts/functions.sh
source fairsoft/config.cache

# check the architecture automatically
# set the compiler options according to architecture, compiler
# debug and optimization options
export Fortran_Needed=TRUE
export SIMPATH=$PWD/fairsoft
export SIMPATH_INSTALL=$SIMPATH_INSTALL
export install_prefix=$SIMPATH_INSTALL
source fairsoft/scripts/check_system.sh

export SIMPATH=$source_dir
cd $source_dir

echo "The following parameters are set." | tee -a $logfile
echo "System              : " $system | tee -a $logfile
echo "C++ compiler        : " $CXX | tee -a $logfile
echo "C compiler          : " $CC | tee -a $logfile
echo "Fortran compiler    : " $FC | tee -a $logfile
echo "CXXFLAGS            : " $CXXFLAGS | tee -a $logfile
echo "CFLAGS              : " $CFLAGS | tee -a $logfile
echo "FFLAGS              : " $FFLAGS | tee -a $logfile
echo "CMAKE BUILD TYPE    : " $BUILD_TYPE | tee -a $logfile
echo "Compiler            : " $compiler | tee -a $logfile
echo "Fortran compiler    : " $FC
echo "Debug               : " $debug | tee -a $logfile
echo "Optimization        : " $optimize | tee -a $logfile
echo "Platform            : " $platform | tee -a $logfile
echo "Architecture        : " $arch | tee -a $logfile
echo "Number of parallel    " | tee -a $logfile
echo "processes for build : " $number_of_processes | tee -a $logfile
echo "Installation Directory: " $SIMPATH_INSTALL | tee -a $logfile

######################## VC ################################

if [ "$check" = "1" ];
then
  source scripts/install_vc.sh  
fi

if [ "$check" = "1" ];
then
  if [ ! -e Cbm_Millepede_Version ];then
    echo "MILLEPEDE_VERSION: $MILLEPEDE_VERSION"
    rm $SIMPATH_INSTALL/bin/pede
    rm $SIMPATH_INSTALL/lib/libMille.*
    rm $SIMPATH_INSTALL/include/Mille.h
  fi
  source scripts/install_millepede.sh
  if [ "$check" = "1" ];then
    if [ ! -e Cbm_Millepede_Version ];then
      echo "$MILLEPEDE_VERSION" >> Cbm_Millepede_Version
    fi
  fi      
fi

if [ "$check" = "1" ];
then
  source scripts/install_eigen3.sh  
fi

if [ "$check" = "1" ];
then
  source scripts/install_gbl.sh  
fi

if [ "$check" = "1" ];
then
  source scripts/install_cpprestsdk.sh  
fi
