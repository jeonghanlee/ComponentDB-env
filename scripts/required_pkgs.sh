#!/usr/bin/env bash
#
#  author  : Jeong Han Lee
#  email   : jeonghan.lee@gmail.com
#  date    : 2020 09 10 17:28
#  version : 0.0.2


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

function centos_dist
{

    local VERSION_ID
    eval $(cat /etc/os-release | grep -E "^(VERSION_ID)=")
    echo ${VERSION_ID}
}


function find_dist
{

    local dist_id dist_cn dist_rs PRETTY_NAME
    
    if [[ -f /usr/bin/lsb_release ]] ; then
     	dist_id=$(lsb_release -is)
     	dist_cn=$(lsb_release -cs)
     	dist_rs=$(lsb_release -rs)
     	echo "$dist_id" "${dist_cn}" "${dist_rs}"
    else
        #shellcheck disable=SC2046 disable=SC2002
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
    apt update -y
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


# Don't test it
function centos7_pkgs
{
    yum update
    yum install -y \
	wget curl \
	sed unzip \
	mariadb-server mariadb-server-utils \
	platform-python-setuptools \
	platform-python-pip \
	python-click \
	python-ldap \
	python-sphinx \
	twine \
	python-cherrypy \
	python-routes \
	python-sqlalchemy \
	python-mysql \
	python-suds
}


function centos8_pkgs
{
    dnf update
    dnf install -y \
	wget curl \
	sed unzip \
	mariadb-server mariadb-server-utils \
	platform-python-setuptools \
	platform-python-pip \
	python3-click \
	python3-ldap \
	python3-sphinx \
	twine \
	python3-cherrypy \
	python3-routes \
	python3-sqlalchemy \
	python3-mysql \
	python3-suds

}


dist="$(find_dist)"

case "$dist" in
    *Debian*) debian_pkgs ;;
    *Ubuntu*) debian_pkgs ;;
    *CentOS*)
	centos_version=$(centos_dist)
	if [ "$centos_version" == "8" ]; then
	    centos8_pkgs
	else
	    # assume there is no CentOS6
	    centos7_pkgs
	fi
	;;
    *)
	printf "\\n";
	printf "Doesn't support the detected %s\\n" "$dist";
	printf "Please contact jeonghan.lee@gmail.com\\n";
	printf "\\n";
	exit;
	;;
esac

#define_python_path "$1"
