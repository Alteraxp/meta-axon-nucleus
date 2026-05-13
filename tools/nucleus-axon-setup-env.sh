#!/bin/bash
#
# Nucleus Yocto Project Build Environment Setup Script for the Axon board

ROOTDIR=$(pwd)
BUILD_DIR=""

usage()
{
    echo -e "\nUsage: source nucleus-axon-setup-env.sh
    Optional parameters: [-b build-dir] [-h]"
    echo "
    * [-b build-dir]: Build directory, if unspecified script uses 'build-axon' as output directory
    * [-h]: help
    "
}

exit_message ()
{
   echo "To return to this build environment later please run:"
   echo "    source setup-environment <build_dir>"
}

clean_up()
{
    unset ROOTDIR BUILD_DIR
    unset fsl_setup_help fsl_setup_error fsl_setup_flag
    unset usage clean_up exit_message
}

# get command line options
OLD_OPTIND=$OPTIND

while getopts "b:h" fsl_setup_flag
do
    case $fsl_setup_flag in
    b) BUILD_DIR="$OPTARG";
        ;;
    h) fsl_setup_help='true';
        ;;
    \?) fsl_setup_error='true';
        ;;
    esac
done

shift $((OPTIND-1))
if [ $# -ne 0 ]; then
    fsl_setup_error=true
    echo -e "Invalid command line ending: '$@'"
fi
OPTIND=$OLD_OPTIND

if [ -z "$BUILD_DIR" ]; then
    BUILD_DIR="build-axon"
fi

# Verify meta-axon-nucleus layer exists
if [ ! -d "${ROOTDIR}/sources/meta-axon-nucleus" ]; then
    echo "ERROR: Layer not found: meta-axon-nucleus"
    clean_up
    return 1
fi

# Allow DL_DIR to be passed through to BitBake from environment
export BB_ENV_PASSTHROUGH_ADDITIONS="${BB_ENV_PASSTHROUGH_ADDITIONS} DL_DIR"

# Set up the Yocto environment using OE init script
TEMPLATECONF="${ROOTDIR}/sources/meta-axon-nucleus/conf/templates/nucleus" \
source ${ROOTDIR}/sources/poky/oe-init-build-env $BUILD_DIR

exit_message
clean_up

