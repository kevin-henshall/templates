#!/usr/bin/env bash

# filename: templates.sh
# author:   Kevin Henshall (kevin.henshall@gmail.com)
# purpose:  front-end script to handle command-line arguments and call the 
# required template installation script

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
UNKNOWN=UNKNOWN
BIN_DIR=`dirname ${0}`
INSTALL_DIR=${BIN_DIR}/..
TEMPLATES_DIR=${INSTALL_DIR}/templates
TEMPLATES_INSTALL_SCRIPT=install.sh

# source shflags for command line parsing
. ${BIN_DIR}/shflags.sh

# define command-line string flags
DEFINE_string 'type' "${UNKNOWN}" 'Type of template to use' 't'
DEFINE_string 'location' "${UNKNOWN}" 'Target project install directory location' 'l'
DEFINE_boolean 'quiet' false 'Enable quiet installation' 'q'
DEFINE_boolean 'available' false 'List available templates' 'a'

# parse the command-line
FLAGS "$@" || exit 1
eval set -- "${FLAGS_ARGV}"

# validate command-line
if [[ ${FLAGS_available} == ${FLAGS_TRUE} ]]
then
    echo "Available templates are:"
    templates_list=`ls -1d ${TEMPLATES_DIR}/*/`
    for template in ${templates_list}
    do
       echo "${template}" | sed 's/.*templates\/\(.*\)\//\t-\1/'
    done
    exit 0
fi
if [[ ${FLAGS_type} == ${UNKNOWN} ]]
then
    error "Project template type not specified"
fi
if [[ ${FLAGS_location} == ${UNKNOWN} ]]
then
    error "Target project install directory location not specified"
fi

# ensure that template type exists
if [[ ! -d ${TEMPLATES_DIR}/${FLAGS_type} ]]
then
    error "Unknow project template type '${FLAGS_type}'"
fi

# ensure that target project location exists and is writable
if [[ ! -d ${FLAGS_location} || ! -w ${FLAGS_location} ]]
then
    error "Target project install directory location does not exist or is not \
writable"
fi

# ensure that the ${TEMPLATES_INSTALL_SCRIPT} exists within 
# ${TEMPLATES_DIR}/${FLAGS_type} and is executable
if [[ ! -f ${TEMPLATES_DIR}/${FLAGS_type}/${TEMPLATES_INSTALL_SCRIPT} || ! -x \
${TEMPLATES_DIR}/${FLAGS_type}/${TEMPLATES_INSTALL_SCRIPT} ]]
then
    error "Installation script ${TEMPLATES_INSTALL_SCRIPT} was not found \
within ${TEMPLATES_DIR}/${FLAGS_type} or was not executable"
fi

# run ${TEMPLATES_INSTALL_SCRIPT} from ${TEMPLATES_DIR}/${FLAGS_type} (passing 
# ${FLAGS_location} as an argument) to perform required installation steps
${TEMPLATES_DIR}/${FLAGS_type}/${TEMPLATES_INSTALL_SCRIPT} -l ${FLAGS_location}
install_return_code=$?

# ensure ${TEMPLATES_INSTALL_SCRIPT} was successful
if [[ ${install_return_code} != 0 ]]
then
    error "An error was encounted while executing \
${TEMPLATES_DIR}/${FLAGS_type}/${TEMPLATES_INSTALL_SCRIPT}. Please review \
output and action appropriately"
fi

# display README file
if [[ ${FLAGS_quiet} == ${FLAGS_FALSE} ]]
then
    read -p "Would you like to display the README file? (y/n) " input
    if [[ ${input} == 'y' || ${input} == 'Y' ]]
    then
        # ensure README file exists
        if [[ -f ${TEMPLATES_DIR}/${FLAGS_type}/README ]]
        then
            # display README file
            less ${TEMPLATES_DIR}/${FLAGS_type}/README
        else
            echo "Sorry, there is no README file for this project type. Feel \
free to contribute one so others will not encounter the same problem"
        fi
    fi
fi
