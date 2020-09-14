#!/usr/bin/env bash
#
#  Reused a few function from setEpicsEnv.bash
#  The original Copyright Statement
#  Copyright (c) 2017 - 2018  European Spallation Source ERIC
#  Copyright (c) 2017 - 2020  Jeong Han Lee
#
#  The program is free software: you can redistribute
#  it and/or modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation, either version 2 of the
#  License, or any newer version.
#
#  This program is distributed in the hope that it will be useful, but WITHOUT
#  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
#  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
#  more details.
#
#  You should have received a copy of the GNU General Public License along with
#  this program. If not, see https://www.gnu.org/licenses/gpl-2.0.txt
# 
#   Shell   : setCdbWeb.bash
#   Author  : Jeong Han Lee
#   email   : jeonghan.lee@gmail.com
#   date    : 
#   version : 1.0.0


# the following function drop_from_path was copied from
# the ROOT build system in ${ROOTSYS}/bin/, and modified
# a little to return its result
# Wednesday, July 11 23:19:00 CEST 2018, jhlee 
function drop_from_path
{
    #
    # Assert that we got enough arguments
    if test $# -ne 2 ; then
        echo "drop_from_path: needs 2 arguments"
        return 1
    fi

    local p=$1
    local drop=$2

    local new_path=""
        # shellcheck disable=SC2086
    new_path=$(echo $p | sed -e "s;:${drop}:;:;g" \
                    -e "s;:${drop};;g"   \
                    -e "s;${drop}:;;g"   \
                    -e "s;${drop};;g";)
    echo "${new_path}"
}


function set_variable
{
    if test $# -ne 2 ; then
        echo "set_variable: needs 2 arguments"
        return 1
    fi

    local old_path="$1"
    local add_path="$2"

    local new_path=""
    local system_old_path=""

    if [ -z "$old_path" ]; then
        new_path=${add_path}
    else
        system_old_path=$(drop_from_path "${old_path}" "${add_path}")
        if [ -z "$system_old_path" ]; then
            new_path=${add_path}
        else
            new_path=${add_path}:${system_old_path}
        fi
    fi

    echo "${new_path}"

}

THIS_SRC=${BASH_SOURCE[0]:-${0}}

if [ -L "$THIS_SRC" ]; then
    # shellcheck disable=SC2046
    SRC_PATH="$( cd -P "$( dirname $(readlink -f "$THIS_SRC") )" && pwd )"
else
    SRC_PATH="$( cd -P "$( dirname "$THIS_SRC" )" && pwd )"
fi


SRC_NAME=${THIS_SRC##*/}

CDB_PATH=${SRC_PATH}
CDB_BIN_PATH=${CDB_PATH}/bin

system_path=${PATH}
will_drop_path="${CDB_BIN_PATH}"
PATH=$(drop_from_path "${system_path}" "${will_drop_path}")
export PATH

old_path=${PATH}
new_PATH="${CDB_BIN_PATH}"
PATH=$(set_variable "${old_path}" "${new_PATH}")
export PATH

rintf "\nSet the EPICS Environment as follows:\n";
printf "THIS Source NAME    : %s\n" "${SRC_NAME}"
printf "THIS Source PATH    : %s\n" "${SRC_PATH}"
printf "CDB BIN PATH        : %s\n" "${CDB_BIN_PATH}"
printf "\n";
printf "Enjoy ComponentDB Web Service CLI!\n";
