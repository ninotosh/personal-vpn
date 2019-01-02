#!/bin/sh -eu

remote=${1:?"Run $0 server_to_connect_to"}

self_dir=`dirname $0`
self_dir=`cd ${self_dir}; pwd`
client_pki_dir="${self_dir}/client/pki"
ovpn_dir="${self_dir}/client/ovpn"
client_template_conf="${self_dir}/../conf/client-template.conf"

function prepare_ovpn_dir() {
    mkdir -p ${ovpn_dir}
    chmod 700 ${ovpn_dir}
}

function _write_ovpn() {
    client=$1
    ca=`cat ${client_pki_dir}/ca.crt`
    cert=`cat ${client_pki_dir}/${client}.crt`
    key=`cat ${client_pki_dir}/${client}.key`
    tls_auth=`cat ${client_pki_dir}/ta.key`
    conf=`cat ${client_template_conf}`
    ovpn=${ovpn_dir}/${client}.ovpn

    cat << EOF | sed "s/\${remote}/${remote}/g" > ${ovpn}
<ca>
${ca}
</ca>
<cert>
${cert}
</cert>
<key>
${key}
</key>
<tls-auth>
${tls_auth}
</tls-auth>
${conf}
EOF

    echo "${ovpn} has been created."
}

function write_all_ovpn() {
    for crt in ${client_pki_dir}/client*.crt; do
        client=`basename ${crt%.*}`
        if [ -f ${client_pki_dir}/${client}.key ]; then
            _write_ovpn ${client}
        fi
    done
}

function remove_client_pki_dir() {
    rm -r ${client_pki_dir}
}

prepare_ovpn_dir
write_all_ovpn
remove_client_pki_dir
