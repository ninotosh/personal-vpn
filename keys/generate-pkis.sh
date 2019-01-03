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

source ./vars.sh

pki_dir="`mktemp -d ${tmp_dir}/XXXXXXXX`"
trap "rm -fr ${pki_dir}" EXIT SIGINT SIGQUIT SIGTERM

function create_pkis() {
    docker run -t --rm \
        -v ${pki_dir}:/mnt \
        -v ${self_dir}/run-easyrsa.sh:/opt/run-easyrsa.sh \
        --entrypoint /opt/run-easyrsa.sh \
        ubuntu:18.10 ${client_count}
}

function copy_server_pki() {
    cp \
        ${pki_dir}/pki/ca.crt \
        ${pki_dir}/pki/issued/myserver.crt \
        ${pki_dir}/pki/private/myserver.key \
        ${pki_dir}/pki/dh.pem \
        ${server_dir}

    echo "server PKI has been created in ${server_dir}"
}

function copy_client_pki() {
    cp \
        ${pki_dir}/pki/ca.crt \
        ${pki_dir}/pki/issued/client*.crt \
        ${pki_dir}/pki/private/client*.key \
        ${client_dir}

    echo "client PKI has been created in ${client_dir}"
}

create_pkis
copy_server_pki
copy_client_pki
