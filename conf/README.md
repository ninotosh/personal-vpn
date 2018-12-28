See https://github.com/OpenVPN/openvpn/tree/master/sample/sample-config-files for `server.conf` and `client.conf`.

Extract active lines with

```bash
curl \
  https://raw.githubusercontent.com/OpenVPN/openvpn/master/sample/sample-config-files/server.conf \
  | grep -v '^#' \
  | grep -v '^;' \
  | grep -v '^$' \
  | sed 's/my-server-1/localhost/g' \
  > default/server.conf
```

```bash
curl \
  https://raw.githubusercontent.com/OpenVPN/openvpn/master/sample/sample-config-files/client.conf \
  | grep -v '^#' \
  | grep -v '^;' \
  | grep -v '^$' \
  | sed 's/my-server-1/localhost/g' \
  > default/client.conf
```
