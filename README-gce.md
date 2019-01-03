##### set an environment variable for the project directory

```bash
project_dir="`pwd`"
```

##### build and push a server image

```bash
cd ${project_dir}/docker-push
make all
```

##### generate certificates and keys

Change the number of clients as needed.
No more client files can be additionally created later.

```bash
cd ${project_dir}/keys
make CLIENTS=5 generate-keys
```

##### initialize `gcloud` configuration

```bash
cd ${project_dir}/gce
make init
```

##### create a GCE instance

```bash
cd ${project_dir}/gce
make create
```

##### upload a server configuration file and a PKI directory

```bash
cd ${project_dir}/gce
make upload
```

##### run a server container on the GCE instance

```bash
cd ${project_dir}/gce
make run
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

----

##### steps to update the container without recreating a GCE instance

1. `cd ${project_dir}/docker-push && make all`
1. `cd ${project_dir}/gce && make upload`
1. `cd ${project_dir}/gce && make docker-restart`
This command will not return when you are on the VPN
because the VPN connection will be lost.
1. `cd ${project_dir}/client && ./run-client.sh ../keys/client/ovpn/client0.ovpn`
1. `cd ${project_dir}/gce && make docker-ps`
