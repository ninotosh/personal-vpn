##### set an environment variable for the project directory

```bash
project_dir="`pwd`"
```

##### build and push a server image

```bash
cd ${project_dir}/docker-push
make all
```

##### create a cluster

This step depends on the cloud platform.

A static IP address must be set up, too.

##### deploy a service

Get and set the static IP address.

```bash
loadBalancerIP="the.static.IP.address"
```

For GCP,

```bash
gcloud beta compute addresses list \
    --filter "region:(${CLOUDSDK_COMPUTE_ZONE%-?})" \
    --filter name=${address_name} \
    --format 'value(address)'
```

Generate a manifest file.

```bash
cd ${project_dir}/k8s
cat openvpn-template.yaml \
| sed "s/\${loadBalancerIP}/${loadBalancerIP}/g" \
> openvpn.yaml
```

Apply the manifest and configurations.

```bash
make up
```

##### generate certificates and keys

Change the number of clients as needed.
No more client files can be additionally created later.

```bash
cd ${project_dir}/keys
make generate-keys -n 5
```

##### generate ovpn file for clients

```bash
cd ${project_dir}/keys
make SERVER="the.static.IP.address" generate-ovpn
```

The active static IP address can be shown with

```bash
make kubectl-show-server-ip
```

##### run a client

```bash
cd ${project_dir}/client
./run-client.sh ../keys/client/pki/client0.ovpn
```

##### notes
###### switching TCP and UDP

- modify Kubernetes manifests
    - `.items[].spec.ports[].protocol` for Services
    - `.items[].spec.containers[].ports[].protocol` for Pods
- modify OpenVPN configurations
    - `proto` for the server
    - `proto` for clients
