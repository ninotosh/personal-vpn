CLIENTS=5
.PHONY: generate-keys
generate-keys:
	./generate-keys.sh -n ${CLIENTS}

IMAGE=
.PHONY: generate-tls-auth-key
generate-tls-auth-key:
ifeq (${IMAGE},)
	$(error specify IMAGE)
endif
	./generate-tls-auth-key.sh ${IMAGE}

SERVER=
.PHONY: generate-ovpn
generate-ovpn:
ifeq (${SERVER},)
	$(error specify SERVER)
endif
	./generate-ovpn.sh ${SERVER}

.PHONY: clean_client
clean_client:
	$(RM) -r client

.PHONY: clean_server
clean_server:
	$(RM) -r server

.PHONY: clean_all
clean_all: clean_client clean_server
