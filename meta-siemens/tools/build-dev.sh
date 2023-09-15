#!/bin/bash -e

MACHINE_NAME="siemens-board"
IMAGE_NAME="siemens-image"
DISTRO_NAME="siemens-distro"
MAIN_DIR=$PWD
RELEASE_DIR=${MAIN_DIR}/update
BUILD_DIR=${MAIN_DIR}/build
LAYER_DIR=${MAIN_DIR}/sources/meta-siemens
DEPLOY_DIR=${BUILD_DIR}/tmp/deploy/images/${MACHINE_NAME}
BUILD_NAME=${IMAGE_NAME}-${MACHINE_NAME}
LANG=en_GB.UTF-8
VERSION=$(grep 'VERSION =' $LAYER_DIR/recipes-tools/update-image/update-image.bb | sed 's/"//g' | sed 's/VERSION = //g')
TYPE=$(grep 'TYPE =' $LAYER_DIR/recipes-tools/update-image/update-image.bb | sed 's/"//g' | sed 's/TYPE = //g')


# Clean up previous build (if any)
#rm -rf ${BUILD_DIRECTORY}

# Use Yocto to build the OS and the cross-toolchain
(
    # Exit on error
    set -e

    # Setup build environment
    #source sources/poky/oe-init-build-env ${BUILD_DIRECTORY}
    DISTRO=${DISTRO_NAME} MACHINE=${MACHINE_NAME} source imx-setup-release.sh -b build
    # Setup build configuration
    source ${LAYER_DIR}/tools/setup-build.sh

    # Build OS
    bitbake ${IMAGE_NAME}

    pwd > ../build-directory.log
)

# Create release directory
rm -rf ${RELEASE_DIR}
mkdir -p ${RELEASE_DIR}
mkdir -p ${UPDATE_DIR}
cd ${RELEASE_DIR}

# Copy the list of installed packages to the release directory
cp ${DEPLOY_DIR}/${BUILD_NAME}.manifest packages.manifest

pwd > ../output-directory.log
exit 0
