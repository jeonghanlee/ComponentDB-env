#!/usr/bin/env bash
#
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  version : 0.0.1

declare -g SC_SCRIPT;
declare -g SC_TOP;
declare -g ENV_TOP;

SC_SCRIPT="$(realpath "$0")";
#SC_SCRIPTNAME=${0##*/};
SC_TOP="${SC_SCRIPT%/*}"
#LOGDATE="$(date +%y%m%d%H%M)"
ENV_TOP="${SC_TOP}/.."
 
# shellcheck disable=SC1090
. "${SC_TOP}/mariadb.conf"

SQL_ROOT_CMD="sudo mysql --user=root"
# shellcheck disable=SC2153
SQL_ADMIN_CMD="mysql --user=${DB_ADMIN_NAME} --password=${DB_ADMIN_PASS} --port=${DB_HOST_PORT} --host=${DB_HOST_IPADDR}"
# shellcheck disable=SC2153
SQL_DBUSER_CMD="mysql --user=${DB_USER_NAME} --password=${DB_USER_PASS} --port=${DB_HOST_PORT} --host=${DB_HOST_IPADDR}"
# shellcheck disable=SC2153
#SQL_BACKUP_CMD="mysqldump --user=${DB_USER_NAME} --password=${DB_USER_PASS} ${DB_NAME}"

EXIST=1
NON_EXIST=0

VERBOSE=

function noDbMessage
{
    local db_name="$1"; shift;
    if [ "$VERBOSE" == "YES" ]; then
        printf ">> There is no >> %s << in the dababase, please check your SQL enviornment.\\n" "${db_name}"
    fi
}



function usage
{
    {
	echo "";
	echo "Usage    : $0 <arg>";
	echo "";
    echo "          <arg>              : info";
	echo "";
	echo "          ssetup             : mariaDB secure installation";
    echo "          adminAdd           : add the admin account";
    echo "";
    # shellcheck disable=SC2153 
    echo "          dbCreate           : create the DB -${DB_NAME}- at -${DB_HOST_NAME}-";
    echo "          dbDrop             : drop   the DB -${DB_NAME}- at -${DB_HOST_NAME}-";
    echo "          dbShow             : show all dbs exist";
    echo "          tableCreate        : create the tables";
    echo "          tableDrop          : drop   the tables";
    echo "          tableShow          : show   the tables";
    echo "          viewCreate         : create the views";
    echo "          viewDrop           : drop   the views";
    echo "          viewShow           : show   the views";
    echo "          sProcCreate        : create the stored_procedures";
    echo "          sProcDrop          : drop   the stored_procedures";
    echo "          sProcShow          : show   the stored_procedures";
    echo "";
    echo "          allCreate          : create the tables, views, and stored_procedures";
    echo "          allViews           : show the tables, views, and stored_procedures";
    echo "          allDrop            : drop the tables, views, and stored_procedures";
    echo "";
    echo "          query \"sql query\"  : Send any sql query to DB -${DB_NAME}-"
    echo "";
    } 1>&2;
    exit 1;
}

# 1 : MariaDB Hostname 
# 2 : MariaDB IP address 
function mariadb_secure_setup
{
    local db_hostname="$1"; shift;
    local db_host_ipaddr="$1"; shift;

    # MariaDB Secure Installation without MariaDB root password
    # the same as mysql_secure_installation, but skip to setup
    # the root password in the script. The reference of the sql commands
    # is https://goo.gl/DnyijD

    # remove_anonymous_users()
    # remove_remote_root()
    # remove_test_database()
    # reload_privilege_tables()
    printf ">> MariaDB Secure Installation\\n";
    # shellcheck disable=SC2154
    ${SQL_ROOT_CMD} <<EOF
    -- DELETE FROM mysql.user WHERE User='';
    DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('${db_hostname}', '${db_host_ipaddr}', '::1');
    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    FLUSH PRIVILEGES;
EOF
    printf "\\n"
}


# 1 : MariaDB Hostname 
# 2 : MariaDB Admin username 
# 3 : MariaDB Admin password
# 3 : MariaDB Admin password
function add_admin_account 
{
    local db_hostname="$1"; shift;
    local db_admin_name="$1"; shift;
    local db_admin_pass="$1"; shift;
    # add admin user with the password via the environment variable $CDB_ADMIN_PWD
    #
    #
    printf ">> Add %s user with GRANT ALL in the MariaDB \\n" "${db_admin_name}"
    ${SQL_ROOT_CMD} <<EOF
    GRANT ALL ON *.* TO '${db_admin_name}'@'${db_hostname}' IDENTIFIED BY '${db_admin_pass}' WITH GRANT OPTION;
    FLUSH PRIVILEGES;
EOF
    printf "\\n"
}


# 1 : MariaDB Hostname 
# 2 : MariaDB Database name 
# 3 : User name of the database
# 4 : User password for the user of the database
function create_db 
{
    local db_hostname="$1"; shift;
    local db_name="$1"; shift;
    local db_user_name="$1"; shift;
    local db_user_pass="$1"; shift;
    local db_char_set="utf8"

    printf ">> Create the Database %s if not exists with %s and its user name %s \\n" "${db_name}" "${db_char_set}" "${db_user_name}"
    ${SQL_ADMIN_CMD} <<EOF
CREATE DATABASE IF NOT EXISTS ${db_name} CHARACTER SET ${db_char_set}; GRANT ALL PRIVILEGES ON ${db_name}.* TO '${db_user_name}'@'${db_hostname}' IDENTIFIED BY '${db_user_pass}';
EOF
    printf "\\n"
}

# 1 : MariaDB Database name 
# SQL_ADMIN_CMD contains host information which the command can be executed. 
function drop_db
{
    local db_name="$1"; shift;
    if [ "$verbose" == "YES" ]; then
        printf ">> Drop the Database %s \\n" "${db_name}";
    fi

    ${SQL_ADMIN_CMD} <<EOF
DROP DATABASE IF EXISTS ${db_name};
EOF
    printf "\\n"
}


function show_dbs
{
    local dBs;
    local cmd;
    cmd+="$SQL_ADMIN_CMD";
    cmd+=" ";
    cmd+="-N";
    cmd+=" ";   
    cmd+="--execute=\"";
    # The following cmd contains only mysql standard query
    cmd+="SHOW DATABASES;";
    cmd+="\"";
    commandPrn "$cmd"
    dBs=$(eval "${cmd}" | awk '{print $1}')
    for db in $dBs
    do
        printf ">>>>> %24s was found.\n" "${db}"
    done
}

# 1 : database name
# If the database exists,        it returns 1
# If the database doesn't exist, it returns 0
function isDb 
{
    local db_name="$1"; shift;
    local verbose="$1"; shift;

    local outputs;
    local cmd;
    cmd+="$SQL_ADMIN_CMD";
    cmd+=" ";
    cmd+="-N";
    cmd+=" ";   
    cmd+="--execute=\"";
    # The following cmd contains only mysql standard query
    cmd+="SELECT schema_name FROM information_schema.schemata WHERE schema_name='${db_name}'";
    cmd+="\"";
    outputs=$(eval "${cmd}" | awk '{print $1}')
    if [ "$verbose" == "YES" ]; then
        commandPrn "$cmd"
        printf "We've found the DB -%s- \\n" "$outputs";
    else
        local result=""
        if [[ -z "${outputs}" ]]; then
            result=${NON_EXIST} # does not exist
        else
            result=${EXIST}     # exists
        fi
        echo "${result}"
    fi
}   

function commandPrn
{
    local cmd="$1"; shift;   
    if [ "$VERBOSE" == "YES" ]; then
        printf ">> command :\\n"
        printf "%s\\n" "$cmd"
        printf ">>\\n"
    fi
}

# 1 : database name
# 2 : sql file (with path) for database creation
function create_from_sql_file
{
    local db_name="$1"; shift;
    local sql_file="$1"; shift;
    local db_exist;
    local cmd;

    db_exist=$(isDb "${db_name}");

    if [[ $db_exist -ne "$EXIST" ]]; then
   	    noDbMessage "${db_name}";
	    exit;
    else
        cmd+="$SQL_DBUSER_CMD";
        cmd+=" ";
        cmd+="${db_name}";
        cmd+=" ";
        cmd+="<";
        cmd+=" ";
        cmd+=""\";   
        cmd+="${sql_file}";
        cmd+="\"";
        # The following cmd contains only mysql standard query
        commandPrn "$cmd"
        eval "${cmd}"
    fi
}

function populate_cdb_static_sql
{
    input3="${ENV_TOP}/ComponentDB-src/db/sql/create_stored_procedures.sql"
}


# 1 : database name
function show_tables
{
    local db_name="$1"; shift;
    local type="$1"; shift;
    local db_exist;
    local tables;
    local cmd;
    local i;
    i=0;
    db_exist=$(isDb "${db_name}");
    
    if [[ $db_exist -ne "$EXIST" ]]; then
	    noDbMessage "${db_name}";
	    exit;
    else
        cmd+="$SQL_DBUSER_CMD";
        cmd+=" ";
        cmd+="${db_name}";
        cmd+=" ";
        cmd+="-N";
        cmd+=" ";   
        cmd+="--execute=\"";
        # The following cmd contains only mysql standard query
        cmd+="SHOW FULL TABLES WHERE Table_type='${type}'"
        cmd+=";\"";
        commandPrn "$cmd"
        tables=$(eval "${cmd}" | awk '{print $1}')
        printf "\n";
        # shellcheck disable=SC2206
        declare -a  table_array=( ${tables} )
   	    for table in $tables
	    do
            ((++i))
            ((++j))
            printf ">> %4d/%4d/%4d<< %40s\\n" "$j" "$i" "${#table_array[@]}" "${table}"
	    done
    fi
    
}


# 1 : database name
function show_procedures
{
    local db_name="$1"; shift;
    local db_exist;
    local outputs;
    local cmd;
    local i;
    i=0;

    db_exist=$(isDb "${db_name}");
    
    if [[ $db_exist -ne "$EXIST" ]]; then
	    noDbMessage "${db_name}";
	    exit;
    else
        cmd+="$SQL_DBUSER_CMD";
        cmd+=" ";
        cmd+="${db_name}";
        cmd+=" ";
        cmd+="-N";
        cmd+=" ";   
        cmd+="--execute=\"";
        # The following cmd contains only mysql standard query
        cmd+="SHOW PROCEDURE STATUS"
        cmd+=";\"";
        commandPrn "$cmd"
        outputs=$(eval "${cmd}" | awk '{print $2}')
        printf "\n";
        # shellcheck disable=SC2206
        declare -a  array=( ${outputs} )
   	    for output in $outputs
	    do
            ((++i))
            ((++j))
            printf ">> %4d/%4d/%4d<< %40s\\n" "$j" "$i" "${#array[@]}" "${output}"

	    done
    fi
    
}



# 1 : database name
function drop_tables
{
    local db_name="$1"; shift;
    local type="$1"; shift;
    local tables;
    local db_exist;
    local cmd;
    local dropCmd;
    db_exist=$(isDb "${db_name}");

    if [[ $db_exist -ne "$EXIST" ]]; then
	    noDbMessage "${db_name}";
	    exit;
    else
        cmd+="$SQL_DBUSER_CMD";
        cmd+=" ";
        cmd+="${db_name}";
        cmd+=" ";
        cmd+="-N";
        cmd+=" ";   
        cmd+="--silent"
        cmd+=" ";   
        cmd+="--execute=\"";
        # The following cmd contains only mysql standard query
        # It is ok to get all table and views, because we only use DROP TABEL query
        cmd+="SHOW FULL TABLES WHERE Table_type='${type}'"
        cmd+=";\"";
        commandPrn "$cmd"
        tables=$(eval "${cmd}" | awk '{print $1}' )
        if [ "$tables" ]; then
            # shellcheck disable=SC2086
            tables_cmd=$(echo ${tables} | tr -s ' ' ',')
            printf "\n";
            dropCmd+="$SQL_DBUSER_CMD";
            dropCmd+=" ";
            dropCmd+="${db_name}";
            dropCmd+=" ";
            dropCmd+="--execute=\"";
            # Ignore all table orders, drop all
            dropCmd+="SET foreign_key_checks = 0;"
            if [ "$type" == "VIEW" ]; then
                dropCmd+="DROP VIEW IF EXISTS ${tables_cmd};"
            else
                dropCmd+="DROP TABLE IF EXISTS ${tables_cmd};"
            fi
            dropCmd+="SET foreign_key_checks = 1"
            dropCmd+=";\"";
       
            commandPrn "$dropCmd"
            eval "${dropCmd}"
        fi

    fi

}


# 1 : database name
function drop_procedures
{
    local db_name="$1"; shift;
    local db_exist;
    local cmd;
    local dropCmd;
    db_exist=$(isDb "${db_name}");

    if [[ $db_exist -ne "$EXIST" ]]; then
	    noDbMessage "${db_name}";
	    exit;
    else
        cmd+="$SQL_DBUSER_CMD";
        cmd+=" ";
        cmd+="${db_name}";
        cmd+=" ";
        cmd+="-N";
        cmd+=" ";   
        cmd+="--silent"
        cmd+=" ";   
        cmd+="--execute=\"";
        # The following cmd contains only mysql standard query
        # It is ok to get all table and views, because we only use DROP TABEL query
        cmd+="SHOW PROCEDURE STATUS"
        cmd+=";\"";
        commandPrn "$cmd"
        outputs=$(eval "${cmd}" | awk '{print $2}' )
        # shellcheck disable=SC2086

        printf "\n";
        for output in $outputs
        do
            dropCmd="$SQL_DBUSER_CMD";
            dropCmd+=" ";
            dropCmd+="${db_name}";
            dropCmd+=" ";
            dropCmd+="--execute=\"";
            # Ignore all table orders, drop all
            dropCmd+="DROP PROCEDURE IF EXISTS ${output}"
            dropCmd+=";\"";
            if [ "$VERBOSE" == "YES" ]; then
                printf ". %24s was found. Droping .... \n" "${output}"
            fi
	        commandPrn "$dropCmd"
            eval "${dropCmd}"
        done
    fi

}


#printf ">> Show current databases .. with admin account\\n\n"
#${SQL_ADMIN_CMD} -e "SELECT SCHEMA_NAME 'database', default_character_set_name 'charset', DEFAULT_COLLATION_NAME 'collation' FROM information_schema.SCHEMATA;"

# 1 : database name
# 2 : MariaDB query
function execute_query
{
    local db_name="$1"; shift;
    local query="$1"; shift;
    local db_exist;
    local cmd;

    db_exist=$(isDb "${db_name}");

    if [[ $db_exist -ne "$EXIST" ]]; then
   	    noDbMessage "${db_name}";
	    exit;
    else
        cmd+="$SQL_DBUSER_CMD";
        cmd+=" ";
        cmd+="${db_name}";
        cmd+=" ";
        cmd+="--execute=\"";
        cmd+="${query}";
        cmd+="\"";
        # The following cmd contains only mysql standard query
        commandPrn "$cmd"
        eval "${cmd}"
    fi
}


input="$1";shift;
additional_input="$1"; shift;

case "$input" in
    secureSetup)
    	mariadb_secure_setup "${DB_HOST_NAME}" "${DB_HOST_IP_ADDR}";
        ;;
    adminAdd)
        # shellcheck disable=SC2153
        add_admin_account "${DB_HOST_NAME}" "${DB_ADMIN_NAME}" "${DB_ADMIN_PASS}";
        ;;    
    dbCreate)
        if [ -z "${additional_input}" ]; then
            additional_input="${DB_NAME}"
        fi
        # shellcheck disable=SC2153
        create_db "${DB_HOST_NAME}" "${additional_input}" "${DB_USER_NAME}" "${DB_USER_PASS}";
        ;;     
    dbShow)
        show_dbs;
        ;;
    dbDrop)
        if [ -z "${additional_input}" ]; then
            additional_input="${DB_NAME}"
        fi
        drop_db "${additional_input}";
        ;;  
    isDb)
        isDb "${DB_NAME}" "YES";
        ;; 
    tableCreate)
        if [ -z "${additional_input}" ]; then
            additional_input="${ENV_TOP}/ComponentDB-src/db/sql/create_cdb_tables.sql"
        fi
        create_from_sql_file "${DB_NAME}" "${additional_input}";
        ;;    
    tableShow)
        show_tables "${DB_NAME}" "BASE TABLE";
        ;;
    tableDrop)
        drop_tables "${DB_NAME}" "BASE TABLE";
        ;; 
    viewCreate)
        if [ -z "${additional_input}" ]; then
            additional_input="${ENV_TOP}/ComponentDB-src/db/sql/create_views.sql"
        fi
        create_from_sql_file "${DB_NAME}" "${additional_input}";
        ;;
    viewShow)
        show_tables "${DB_NAME}" "VIEW";
        ;;
    viewDrop)
        drop_tables "${DB_NAME}" "VIEW";
        ;;
    sProcCreate)
        if [ -z "${additional_input}" ]; then
            additional_input="${ENV_TOP}/ComponentDB-src/db/sql/create_stored_procedures.sql"
        fi
        create_from_sql_file "${DB_NAME}" "${additional_input}";
        ;;
    sProcShow)
        show_procedures "${DB_NAME}";
        ;;
    sProcDrop)
        drop_procedures "${DB_NAME}";
        ;;
    allCreate)
        input1="${ENV_TOP}/ComponentDB-src/db/sql/create_cdb_tables.sql"
        input2="${ENV_TOP}/ComponentDB-src/db/sql/create_views.sql"
        input3="${ENV_TOP}/ComponentDB-src/db/sql/create_stored_procedures.sql"
        create_from_sql_file "${DB_NAME}" "$input1"
        create_from_sql_file "${DB_NAME}" "$input2"
        create_from_sql_file "${DB_NAME}" "$input3"
        ;;
    allShow)
        show_tables "${DB_NAME}" "BASE TABLE";
        show_tables "${DB_NAME}" "VIEW";
        show_procedures "${DB_NAME}";
        ;;
    allDrop)
        drop_tables "${DB_NAME}" "BASE TABLE";  
        drop_tables "${DB_NAME}" "VIEW";
        drop_procedures "${DB_NAME}";
        ;;        
    query)
         if [ -z "${additional_input}" ]; then
            additional_input="SHOW DATABASES;"
        fi
        execute_query "${DB_NAME}" "$additional_input";
        ;;
    *)
        usage;
    ;;

esac
