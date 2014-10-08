#!/bin/sh
	
########################################
# Name:
#
# about:
#
# Usage:
#
# Author:
# Date:
########################################

PROGNAME=`basename $0`
BASEDIR=`dirname $0`


setup() {
    echo "Starting..."

    . $BASEDIR/vpn.conf

    cat << EOF > $BASEDIR/setup.txt
NicCreate $NIC
NicList
AccountCreate $ACCOUNT /SERVER:$SERVER /HUB:$HUB /USERNAME:$USERNAME /NICNAME:$NIC
AccountPasswordSet $ACCOUNT /PASSWORD:$PASSWORD /TYPE:$TYPE
AccountConnect $ACCOUNT
AccountList
EOF

    /usr/local/vpnclient/vpncmd /client localhost /in:$BASEDIR/setup.txt
    rm $BASEDIR/setup.txt
}

status() {
    cat << EOF > $BASEDIR/status.txt
NicList
AccountList
EOF
    /usr/local/vpnclient/vpncmd /client localhost /in:$BASEDIR/status.txt
    rm $BASEDIR/status.txt
}

usage() {
  echo "usage: $PROGNAME {setup|status|restart}"
}

case "$1" in
'setup')
        setup
        ;;
'status')
        status
        ;;
'restart')
        stop
        start
        ;;
*)
        usage
	;;
esac
