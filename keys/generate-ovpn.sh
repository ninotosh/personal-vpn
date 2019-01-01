#!/bin/sh -eu

remote=${1:?"Run $0 server_to_connect_to"}

self_dir=`dirname $0`
self_dir=`cd ${self_dir}; pwd`
client_pki_dir="${self_dir}/client/pki"
client_template_conf="${self_dir}/../conf/client-template.conf"
client_ovpn="${client_pki_dir}/client1.ovpn"

function prepare_ovpn() {
    touch ${client_ovpn}
    chmod 600 ${client_ovpn}
}

function write_ovpn() {
    ca=`cat ${client_pki_dir}/ca.crt`
    cert=`cat ${client_pki_dir}/client1.crt`
    key=`cat ${client_pki_dir}/client1.key`
    tls_auth=`cat ${client_pki_dir}/ta.key`
    conf=`cat ${client_template_conf}`

    cat << EOF | sed "s/\${remote}/${remote}/g" > ${client_ovpn}
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

    echo "${client_ovpn} has been created."
}

prepare_ovpn
write_ovpn
