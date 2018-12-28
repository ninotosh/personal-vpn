##### build and push a server image

```bash
cd docker-push
make all
```

##### generate certificates and keys

```bash
cd keys
make generate-keys
```

##### initialize `gcloud` configuration

```bash
cd gce
make init
```

##### create a GCE instance

```bash
cd gce
make create
```

##### upload a server configuration file and a PKI directory

```bash
cd gce
make upload
```

##### run a server container on the GCE instance

```bash
cd gce
make run
```

##### generate a configuration file for clients

Get the external IP address of the GCE instance.
```bash
cd gce
external_ip_address=`make show-ip`
echo ${external_ip_address}
```

Generate an ovpn file for clients.

```bash
cd keys
make SERVER="${external_ip_address}" generate-ovpn
```

##### run a client

```bash
cd client
./run-client.sh ../keys/client/pki/client1.ovpn
```

##### delete the instance

```bash
cd gce
make delete
```

----

##### steps to update the container without recreating an instance

1. `cd docker-push && make all`
1. `cd gce && make upload`
1. `cd gce && make docker-restart`
This command will not return when you are on the VPN
because the VPN connection will be lost.
1. `cd gce && make docker-ps`
