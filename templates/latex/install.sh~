#!/usr/bin/env bash

# filename: install.sh
# author:   Kevin Henshall (kevin.henshall@gmail.com)
# purpose:  installation script for the latex project

# error function
# arguments:
#   - error message to display
function error() {
    msg=$1
    echo "Error: ${msg}"
    echo "Run ${0} --help for usage"
    exit 1
}

# constants
TEMPLATE_DIR=`dirname ${0}`
BIN_DIR=${TEMPLATE_DIR}/../../bin

# source shflags for command line parsing
. ${BIN_DIR}/shflags.sh

# define command-line string flags
DEFINE_string 'location' "${UNKNOWN}" 'Target project install directory location' 'l'

# parse the command-line
FLAGS "$@" || exit 1
eval set -- "${FLAGS_ARGV}"

# Note: ${FLAGS_location} can be assumed to exist and is writable

# copy the following files to ${FLAGS_location}:
#   - Makefile
#   - document.tex
cp ${TEMPLATE_DIR}/Makefile ${TEMPLATE_DIR}/document.tex ${FLAGS_location}

# Note: exit status should be:
#   - zero on success
#   - non-zero on error
