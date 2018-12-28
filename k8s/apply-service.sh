#!/bin/sh -eu

ip_in_file="`kubectl apply -f openvpn.yaml \
    --dry-run -o jsonpath='{.spec.loadBalancerIP}'`"

if [ -z "${ip_in_file}" ]; then
    echo ".spec.loadBalancerIP is not set"
    exit 1
fi

if which gcloud; then
    exists=`gcloud beta compute addresses list \
        --filter "address=${ip_in_file}" --format 'value(address)'`

    if [ -z "${exists}" ]; then
        echo "${ip_in_file} is set in openvpn.yaml, but does not exist in GCP"
        exit 1
    fi
fi

kubectl apply -f openvpn.yaml
