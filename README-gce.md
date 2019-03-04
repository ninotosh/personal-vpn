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

##### generate certificates and keys

Change the number of clients as needed.
No more client files can be additionally created later.

```bash
cd ${project_dir}/keys
make CLIENTS=5 generate-pkis
```

Generate a TLS auth key to mitigate DoS attack.
```bash
make IMAGE=${docker_hub_image} generate-tls-auth-key
```

##### initialize `gcloud` configuration

```bash
cd ${project_dir}/gce
make init
```

##### create a GCE instance

```bash
cd ${project_dir}/gce
make IMAGE=${docker_hub_image} create
```

##### upload a server configuration file and a PKI directory

```bash
cd ${project_dir}/gce
make upload_all
```

##### run a server container on the GCE instance

```bash
cd ${project_dir}/gce
make IMAGE=${docker_hub_image} docker-run
```

##### generate configuration files for clients

Get the external IP address of the GCE instance.
```bash
cd ${project_dir}/gce
external_ip_address=`make show-ip`
echo ${external_ip_address}
```

Generate ovpn files for clients.

```bash
cd ${project_dir}/keys
make SERVER="${external_ip_address}" generate-ovpn
```

Move ovpn files.

```bash
mv tmp/ovpn/client*.ovpn /path/to/secure/directory
```

##### run a client

```bash
cd ${project_dir}/client
./run-client.sh /path/to/secure/directory/client0.ovpn
```

##### clean key directories

```bash
cd ${project_dir}/keys
make clean
```

----

##### steps to update the container without recreating a GCE instance

1. `cd ${project_dir}/docker-push && make IMAGE=${docker_hub_image} all`
1. `cd ${project_dir}/gce && make init`
1. `cd ${project_dir}/gce && make upload_all`
1. `cd ${project_dir}/gce && make IMAGE=${docker_hub_image} docker-pull-restart`
1. `cd ${project_dir}/gce && make docker-ps`
1. `cd ${project_dir}/client && ./run-client.sh ../keys/client/ovpn/client0.ovpn`

note: `make docker-pull-restart` may not return a command prompt
when you are on the VPN
because the VPN connection will be lost.

##### steps to update the server configuration

1. `cd ${project_dir}/gce && make init`
1. `cd ${project_dir}/gce && make upload_conf`
1. `cd ${project_dir}/gce && make docker-restart`
1. `cd ${project_dir}/gce && make docker-ps`
1. `cd ${project_dir}/client && ./run-client.sh ../keys/client/ovpn/client0.ovpn`
