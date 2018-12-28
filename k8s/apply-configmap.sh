#!/bin/sh -eu

server_conf="../conf/server.conf"

if kubectl get configmap server-configmap; then
    kubectl create configmap server-configmap \
    --from-file ${server_conf} --dry-run -o yaml \
    | kubectl replace configmap server-configmap -f -
else
    kubectl create configmap server-configmap \
    --from-file ${server_conf}
fi
