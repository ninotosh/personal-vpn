#!/bin/sh -eu

apt update && apt install -y easy-rsa=3.0.4-2
cd /mnt

if [ -e pki ]; then
    echo "pki directory already exists"
    exit 1
fi

easyrsa="/usr/share/easy-rsa/easyrsa"

$easyrsa init-pki
# Creates a new CA
# writing new private key to '/root/ca/pki/private/ca.key.xxxxxxxxxx'
$easyrsa --batch build-ca nopass
# Generate a keypair and sign locally for a client or server
# writing new private key to /root/ca/pki/private/myserver.key.xxxxxxxxxx
$easyrsa build-server-full myserver nopass
# Generate a keypair and sign locally for a client or server
# writing new private key to '/root/ca/pki/private/client1.key.xxxxxxxxxx'
$easyrsa build-client-full client1 nopass
# Generates DH (Diffie-Hellman) parameters
$easyrsa gen-dh
