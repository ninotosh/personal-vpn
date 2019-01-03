IMAGE=

.PHONY: all
all: build login push

.PHONY: build
build:
ifeq (${IMAGE},)
	$(error specify IMAGE)
endif
	docker image build \
		-t ${IMAGE} \
		-f Dockerfile-openvpn .

.PHONY: login
login:
	docker login

.PHONY: push
push:
ifeq (${IMAGE},)
	$(error specify IMAGE)
endif
	docker image push ${IMAGE}
