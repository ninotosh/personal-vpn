##### set environment variables for the project

```bash
project_dir="`pwd`"
docker_hub_image="..."
```

`docker_hub_image` is your Dokcer Hub image name such as `username/openvpn`.

##### build and push a server image

```bash
cd ${project_dir}/docker-push
make IMAGE=${docker_hub_image} all
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
| sed "s/\${image}/${docker_hub_image}/g" \
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
make CLIENTS=5 generate-keys
```

Generate a TLS auth key to mitigate DoS attack.
```bash
make IMAGE=${docker_hub_image} generate-tls-auth-key
```

##### generate ovpn files for clients

```bash
cd ${project_dir}/keys
make SERVER="the.static.IP.address" generate-ovpn
```

The active static IP address can be shown with

```bash
cd ${project_dir}/k8s
make show-server-ip
```

Move ovpn files.

```bash
cd ${project_dir}/keys
mv client/ovpn/client*.ovpn /path/to/secure/directory
```

##### run a client

```bash
cd ${project_dir}/client
./run-client.sh /path/to/secure/directory/client0.ovpn
```

##### clean key directories

```bash
cd ${project_dir}/keys
make clean_all
```

`clean_all` is the same as `clean_client` and `clean_server`.

##### notes
###### switching TCP and UDP

- modify Kubernetes manifests
    - `.items[].spec.ports[].protocol` for Services
    - `.items[].spec.containers[].ports[].protocol` for Pods
- modify OpenVPN configurations
    - `proto` for the server
    - `proto` for clients
