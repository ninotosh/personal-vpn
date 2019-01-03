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

build_dir="`cd ${self_dir}/..; pwd`/docker-push"

tmp_dir="${self_dir}/tmp"
tmp_pki_dir="${tmp_dir}/${RANDOM}"

server_pki_dir="${self_dir}/server/pki"
client_pki_dir="${self_dir}/client/pki"

function clean_tmp() {
    echo cleaning ${tmp_dir}
    rm -fr ${tmp_dir}
}

function make_tmp() {
    mkdir -p ${tmp_pki_dir}
    chmod 700 ${tmp_pki_dir}
    trap 'clean_tmp' EXIT SIGINT SIGQUIT SIGTERM
}

function _create_pkis() {
    docker run -t --rm \
        -v ${tmp_pki_dir}:/mnt \
        -v ${self_dir}/run-easyrsa.sh:/opt/run-easyrsa.sh \
        --entrypoint /opt/run-easyrsa.sh \
        ubuntu:18.10 ${client_count}
}

function _reset_server_pki() {
    rm -fr ${server_pki_dir}
    mkdir -p ${server_pki_dir}
    chmod 700 ${server_pki_dir}
}

function _copy_server_pki() {
    _reset_server_pki

    cp \
        ${tmp_pki_dir}/pki/ca.crt \
        ${tmp_pki_dir}/pki/dh.pem \
        ${tmp_pki_dir}/pki/issued/myserver.crt \
        ${tmp_pki_dir}/pki/private/myserver.key \
        ${server_pki_dir}
}

function _reset_client_pki() {
    rm -fr ${client_pki_dir}
    mkdir -p ${client_pki_dir}
    chmod 700 ${client_pki_dir}
}

function _copy_client_pki() {
    _reset_client_pki

    cp \
        ${tmp_pki_dir}/pki/ca.crt \
        ${tmp_pki_dir}/pki/issued/client*.crt \
        ${tmp_pki_dir}/pki/private/client*.key \
        ${client_pki_dir}
}

function create_copy_pkis() {
    _create_pkis
    _copy_server_pki
    _copy_client_pki
}

function _build_openvpn() {
    cd ${build_dir}
    make build
    cd -
}

# for preventing DOS
# https://community.openvpn.net/openvpn/wiki/Hardening#Useof--tls-auth
function _create_psk() {
    _build_openvpn

    docker run -t --rm \
        -v ${tmp_pki_dir}:/mnt \
        --cap-add NET_ADMIN \
        ninotoshi/openvpn \
        --genkey --secret /mnt/ta.key
}

function _copy_psk() {
    cp ${tmp_pki_dir}/ta.key ${server_pki_dir}
    cp ${tmp_pki_dir}/ta.key ${client_pki_dir}
}

function create_copy_psk() {
    _create_psk
    _copy_psk
}

make_tmp
create_copy_pkis
create_copy_psk
