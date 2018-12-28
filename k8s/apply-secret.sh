#!/bin/sh -eu

pki_dir="../keys/server/pki"

if kubectl get secret pki-secret; then
    kubectl create secret generic pki-secret \
    --from-file ${pki_dir} --dry-run -o yaml \
    | kubectl replace secret generic pki-secret -f -
else
    kubectl create secret generic pki-secret \
    --from-file ${pki_dir}
fi
