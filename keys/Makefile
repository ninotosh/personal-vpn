CLIENTS=5
.PHONY: generate-pkis
generate-pkis: _make_tmp
	./generate-pkis.sh -n ${CLIENTS}

IMAGE=
.PHONY: generate-tls-auth-key
generate-tls-auth-key: _make_tmp
ifeq (${IMAGE},)
	$(error specify IMAGE)
endif
	./generate-tls-auth-key.sh ${IMAGE}

SERVER=
.PHONY: generate-ovpn
generate-ovpn: _make_tmp
ifeq (${SERVER},)
	$(error specify SERVER)
endif
	./generate-ovpn.sh ${SERVER}

.PHONY: _make_tmp
_make_tmp:
	[ -d tmp ] || mktemp -d tmp
	[ -d tmp/server ] || mktemp -d tmp/server
	[ -d tmp/client ] || mktemp -d tmp/client

.PHONY: clean
clean:
	@$(RM) -r tmp
