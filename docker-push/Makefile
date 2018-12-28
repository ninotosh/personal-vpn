.PHONY: all
all: build login push

.PHONY: build
build:
	docker image build \
		-t ninotoshi/openvpn \
		-f Dockerfile-openvpn .

.PHONY: login
login:
	docker login

.PHONY: push
push:
	docker image push ninotoshi/openvpn
