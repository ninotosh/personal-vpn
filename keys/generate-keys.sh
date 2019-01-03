#!/bin/sh -eu

client_count=5
while getopts n: OPT; do
    case ${OPT} in
    n)
        client_count=$OPTARG
        ;;
    *)
        echo "usage: $0 [-n client_count]" > /dev/stderr
        exit 1
        ;;
    esac
done

self_dir=`dirname $0`
self_dir=`cd ${self_dir}; pwd`

tmp_dir="`mktemp -d ${self_dir}/tmp_XXXXXXXX`"
trap "rm -fr ${tmp_dir}" EXIT SIGINT SIGQUIT SIGTERM

server_pki_dir="${self_dir}/server/pki"
client_pki_dir="${self_dir}/client/pki"

function create_pkis() {
    docker run -t --rm \
        -v ${tmp_dir}:/mnt \
        -v ${self_dir}/run-easyrsa.sh:/opt/run-easyrsa.sh \
        --entrypoint /opt/run-easyrsa.sh \
        ubuntu:18.10 ${client_count}
}

function _reset_server_pki() {
    rm -fr ${server_pki_dir}
    mkdir -p ${server_pki_dir}
    chmod 700 ${server_pki_dir}
}

function copy_server_pki() {
    _reset_server_pki

    cp \
        ${tmp_dir}/pki/ca.crt \
        ${tmp_dir}/pki/dh.pem \
        ${tmp_dir}/pki/issued/myserver.crt \
        ${tmp_dir}/pki/private/myserver.key \
        ${server_pki_dir}

    echo "server PKI has been created in ${server_pki_dir}"
}

function _reset_client_pki() {
    rm -fr ${client_pki_dir}
    mkdir -p ${client_pki_dir}
    chmod 700 ${client_pki_dir}
}

function copy_client_pki() {
    _reset_client_pki

    cp \
        ${tmp_dir}/pki/ca.crt \
        ${tmp_dir}/pki/issued/client*.crt \
        ${tmp_dir}/pki/private/client*.key \
        ${client_pki_dir}

    echo "client PKI has been created in ${client_pki_dir}"
}

create_pkis
copy_server_pki
copy_client_pki
