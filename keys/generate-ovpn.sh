#!/bin/sh -eu

remote=${1:?"Run $0 server_to_connect_to"}

source ./vars.sh

ovpn_dir="`mktemp -d ${tmp_dir}/ovpn`"

client_template_conf="${self_dir}/../conf/client-template.conf"

function _write_ovpn() {
    client=$1
    ca=`cat ${client_dir}/ca.crt`
    cert=`cat ${client_dir}/${client}.crt`
    key=`cat ${client_dir}/${client}.key`
    tls_auth=`cat ${client_dir}/ta.key`
    conf=`cat ${client_template_conf}`
    ovpn=${ovpn_dir}/${client}.ovpn

    mktemp ${ovpn}
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
    for crt in ${client_dir}/client*.crt; do
        client=`basename ${crt%.*}`
        if [ -f ${client_dir}/${client}.key ]; then
            _write_ovpn ${client}
        fi
    done
}

write_all_ovpn
