#!/bin/bash
set -e

# Compile static libraries

# ARM64 Device
scons target=$2 arch=arm64 plugin=$1 version=$3
# ARM7 Device
scons target=$2 arch=armv7 plugin=$1 version=$3
# x86_64 Simulator
scons target=$2 arch=x86_64 simulator=yes plugin=$1 version=$3

# Creating a fat libraries for device and simulator
# lib<plugin>.<arch>-<simulator|ios>.<release|debug|release_debug>.a

if [[ "$3" == "3.x" ]];
then
    lipo -create "./bin/lib$1.x86_64-simulator.$2.a" \
        "./bin/lib$1.armv7-iphone.$2.a" \
        "./bin/lib$1.arm64-iphone.$2.a" \
        -output "./bin/$1.$2.a"
else
    lipo -create "./bin/lib$1.x86_64-simulator.$2.a" \
        "./bin/lib$1.armv7-ios.$2.a" \
        "./bin/lib$1.arm64-ios.$2.a" \
        -output "./bin/$1.$2.a"
fi    