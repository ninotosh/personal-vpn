#!/bin/sh -eu

ovpn=${1:?"Run $0 /path/to/client.ovpn"}

openvpn="openvpn"

if ! which openvpn; then
    if [ "`uname`" == "Darwin" ]; then
        # also installs lz4, lzo, openssl
        brew list openvpn || brew install openvpn
        openvpn_dir=`brew info openvpn | grep /usr/local | cut -f 1 -d ' '`
        openvpn="${openvpn_dir}/sbin/openvpn"
    #elif ...
    else
        echo "openvpn command not found" > /dev/stderr
        exit 1
    fi
fi

sudo ${openvpn} --config ${ovpn}
