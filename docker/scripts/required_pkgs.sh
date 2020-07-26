#!/usr/bin/env bash
#
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  date    : Monday, June 29 14:02:20 PDT 2020
#  version : 0.0.1


declare -g SC_SCRIPT;
#declare -g SC_SCRIPTNAME;
declare -g SC_TOP;
#declare -g LOGDATE;

SC_SCRIPT="$(realpath "$0")";
#SC_SCRIPTNAME=${0##*/};
SC_TOP="${SC_SCRIPT%/*}"
#LOGDATE="$(date +%y%m%d%H%M)"

function pushd { builtin pushd "$@" > /dev/null || exit; }
function popd  { builtin popd  > /dev/null || exit; }

function find_dist
{

    local dist_id dist_cn dist_rs PRETTY_NAME
    
    if [[ -f /usr/bin/lsb_release ]] ; then
     	dist_id=$(lsb_release -is)
     	dist_cn=$(lsb_release -cs)
     	dist_rs=$(lsb_release -rs)
     	echo "$dist_id" "${dist_cn}" "${dist_rs}"
    else
     	eval $(cat /etc/os-release | grep -E "^(PRETTY_NAME)=")
	echo "${PRETTY_NAME}"
    fi
}


function define_python_path
{
    local pythonpath="$1"
    echo "PYTHONPATH=${pythonpath}" > "${SC_TOP}/.sourceme"
    echo "export PYTHONPATH"       >> "${SC_TOP}/.sourceme"
    chmod +x "${SC_TOP}/.sourceme"
    
}

function debian_pkgs
{
    ## The following packages are listed in install_python_packages.sh via `make support`
    ## ComponentDB-src/support/bin/install_python_packages.sh 
    ## python-setuptools \
    ## python-click \
    ## python2.7-ldap \
    ## python-pip \
    ## python-sphinx \
    ## twine \
    ## python-cherrypy \
    ## python-routes \
    ## python-sqlalchemy \
    ## python-mysqldb \
    ## python-suds 
    ## ---------------------
    ## Debian 10
    apt update
    apt install -y \
    	wget \
        curl \
        expect \
    	git \
        openssl \
    	sed \
        gawk \
        unzip \
        make \
        cmake \
        build-essential \
        gcc \
    	libssl-dev \
        libldap2-dev \
        libsasl2-dev \
        libcurses-ocaml-dev \
    	mariadb-server \
        mariadb-client  \
        libmariadbclient-dev \
        maven \
        ant \
        python-setuptools \
        python-click \
        python2.7-ldap \
        python-pip \
        python-sphinx \
        twine \
        python-cherrypy \
        python-routes \
        python-sqlalchemy \
        python-mysqldb \
        python-suds 
    
    ln -sf "$(which mariadb_config)" /usr/bin/mysql_config
    # MySQL-python-1.2.5 doesn't work with mariadb 
    # https://lists.launchpad.net/maria-developers/msg10744.html
    # https://github.com/DefectDojo/django-DefectDojo/issues/407
    
    if [ ! -f /usr/include/mariadb/mysql.h.bkp ]; then
        sed '/st_mysql_options options;/a unsigned int reconnect;' /usr/include/mariadb/mysql.h -i.bkp
    fi
}

## Do not test it yet Monday, June 29 15:09:24 PDT 2020
function centos_pkgs
{
    yum update
    yum install -y \
	wget curl expect \
	git \ 
        sed gawk unzip \
	make cmake autoconf automake gcc libgcc \
	zlib-devel openssl-devel openldap-devel readline-devel \
	mariadb-server mariadb-libs
	
    ln -sf "$(which mariadb_config)" /usr/bin/mysql_config  
}


dist="$(find_dist)"

case "$dist" in
    *Debian*) debian_pkgs ;;
    *Ubuntu*) debian_pkgs ;;
#    *CentOS*) centos_pkgs ;;
#    *RedHat*) centos_pkgs ;;
    *)
	printf "\\n";
	printf "Doesn't support the detected %s\\n" "$dist";
	printf "Please contact jeonghan.lee@gmail.com\\n";
	printf "\\n";
	exit;
	;;
esac


define_python_path "$1"
