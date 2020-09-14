#!/usr/bin/env bash
#
#  Redesigned scripts based on ComponentDB/bin/*
#  The original Copyright Statement
#  ----------------------------------------------------------
#  Copyright (c) UChicago Argonne, LLC. All rights reserved.
#  See LICENSE.ComponentDB file.
#  ----------------------------------------------------------
# 
#  Copyright (c) 2020   Jeong Han Lee
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
#  Modified version of cdb_command_setup.sh
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  version : 0.0.1


CDB_COMMAND_ARGS=""
while [ $# -ne 0 ]; do
    arg="$1"
    if [[ $arg == -* ]]; then
        key=$(echo "$arg" | cut -f1 -d'=')
        keyHasValue=$(echo "$arg" | grep '=')
        if [ -n "$keyHasValue" ]; then
            value=$(echo "$arg" | cut -f2- -d'=')
            CDB_COMMAND_ARGS="$CDB_COMMAND_ARGS $key=\"$value\""
        else
            CDB_COMMAND_ARGS="$CDB_COMMAND_ARGS $key"
        fi
    else
        CDB_COMMAND_ARGS="$CDB_COMMAND_ARGS \"$arg\""
    fi
    shift;
done
