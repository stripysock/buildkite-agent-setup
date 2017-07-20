#!/bin/bash
#
# This script is intended to be used in an non-admin account
# Dependencies (installed with an admin account):
#  - rbenv (installed by brew)
#  - Xcode (with developer mode enabled etc)
#  - Android Studio (installed by brew)

# Exit on any error
set -e

# Make sure ~/.bash_profile exists
BASH_PROFILE="${HOME}/.bash_profile"
[[ -f ${BASH_PROFILE} ]] || touch ${BASH_PROFILE}

# Set the prompt to green so that remote users know they where they are
grep PS1 ${BASH_PROFILE} > /dev/null || echo 'export PS1="\e[1;32m\u@\h:\w \e[m"' >> ${BASH_PROFILE}

# Initialise rbenv on login
grep "rbenv init" ${BASH_PROFILE} > /dev/null || echo 'eval "$(rbenv init -)"' >> ${BASH_PROFILE}
