.PHONY: generate-keys
generate-keys:
	./generate-keys.sh

SERVER=
.PHONY: generate-ovpn
generate-ovpn:
ifeq (${SERVER},)
	$(error specify SERVER)
endif
	./generate-ovpn.sh ${SERVER}
