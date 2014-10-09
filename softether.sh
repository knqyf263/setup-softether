#!/bin/sh
	
########################################
# Name: Set SoftEtherVPN
#
# about: easy to set softethervpn
#
# Usage: softether.sh {setup|status|disconnect|delete}
#
# Author: Teppei Fukuda
# Date: 2014/10/08
########################################

PROGNAME=`basename $0`
BASEDIR=`dirname $0`

. $BASEDIR/vpn.conf

setup() {
    echo "Starting..."


    cat << EOF > $BASEDIR/setup.txt
NicCreate $NIC
NicList
AccountCreate $ACCOUNT /SERVER:$SERVER /HUB:$HUB /USERNAME:$USERNAME /NICNAME:$NIC
AccountPasswordSet $ACCOUNT /PASSWORD:$PASSWORD /TYPE:$TYPE
AccountConnect $ACCOUNT
AccountList
EOF

    /usr/local/vpnclient/vpncmd /client localhost /in:$BASEDIR/batch.txt
    rm $BASEDIR/batch.txt
}

status() {
    cat << EOF > $BASEDIR/status.txt
NicList
AccountList
EOF
    /usr/local/vpnclient/vpncmd /client localhost /in:$BASEDIR/batch.txt
    rm $BASEDIR/batch.txt
}

disconnect() {
    cat << EOF > $BASEDIR/status.txt
AccountDisconnect $ACCOUNT
AccountList
EOF
    /usr/local/vpnclient/vpncmd /client localhost /in:$BASEDIR/status.txt
    rm $BASEDIR/status.txt
}

delete() {
    cat << EOF > $BASEDIR/status.txt
AccountDisconnect $ACCOUNT
AccountDelete $ACCOUNT
AccountList
NicDelete $NIC
NicList
EOF
    /usr/local/vpnclient/vpncmd /client localhost /in:$BASEDIR/status.txt
    rm $BASEDIR/status.txt
}

usage() {
  echo "usage: $PROGNAME {setup|status|disconnect|delete}"
}

case "$1" in
'setup')
        setup
        ;;
'status')
        status
        ;;
'delete')
	delete
        ;;
'disconnect')
	disconnect
        ;;
*)
        usage
	;;
esac
