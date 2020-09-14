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
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  version : 0.0.1

declare -g SC_RPATH;
#declare -g SC_NAME;
declare -g SC_TOP;
#declare -g SC_TIME;

SC_RPATH="$(realpath "$0")";
#SC_NAME=${0##*/};
SC_TOP="${SC_RPATH%/*}"
#SC_TIME="$(date +%y%m%d%H%M)"

set -a
# shellcheck disable=SC1091,SC1090
. "${SC_TOP}/cdb-cli.conf"
set +a

# shellcheck disable=SC1091,SC1090
. "${SC_TOP}/cdb_command_setup.sh"

cmd="${CDB_PYTHON_CDB_DIR}/"
cmd+="cdb_web_service/cli/"
cmd+="deleteLogCli.py"

eval "$cmd" "$CDB_COMMAND_ARGS"
