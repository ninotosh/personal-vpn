#!/bin/sh -eu

client_count=${1:-1} # 1 by default

cd /mnt

if [ -e pki ]; then
    echo "pki directory already exists"
    exit 1
fi

apt update && apt install -y easy-rsa=3.0.4-2
easyrsa="/usr/share/easy-rsa/easyrsa"

$easyrsa init-pki

# Creates a new CA
# writing new private key to '/mnt/pki/private/ca.key.xxxxxxxxxx'
$easyrsa --batch build-ca nopass

# Generate a keypair and sign locally for a client or server
# writing new private key to /mnt/pki/private/myserver.key.xxxxxxxxxx
$easyrsa build-server-full myserver nopass

# Generate a keypair and sign locally for a client or server
# writing new private key to '/mnt/pki/private/client.key.xxxxxxxxxx'
i=0
while [ $i -lt ${client_count} ]; do
    $easyrsa build-client-full client${i} nopass
    i=`expr $i + 1`
done

# Generates DH (Diffie-Hellman) parameters
$easyrsa gen-dh
