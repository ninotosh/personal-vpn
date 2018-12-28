#!/bin/sh -eu

self_dir=`dirname $0`
self_dir=`cd ${self_dir}; pwd`
host_pki_dir="${self_dir}/../keys/server/pki"
host_conf_file="${self_dir}/../conf/server.conf"

if [ ! -f ${host_conf_file} ]; then
    echo "conf_file ${host_conf_file} not found"
    exit 1
fi

docker run -it --rm \
    --name openvpn_server \
    -v ${host_conf_file}:/etc/openvpn/server.conf \
    -v ${host_pki_dir}:/mnt \
    -p 0.0.0.0:443:443/tcp \
    --device /dev/net/tun \
    --cap-add NET_ADMIN \
    ninotoshi/openvpn \
    --config /etc/openvpn/server.conf
