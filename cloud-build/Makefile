.PHONY: create-docker-hub-keyring
create-docker-hub-keyring:
	gcloud kms keyrings create docker-hub-keyring --location global

.PHONY: list-keyrings
list-keyrings:
	gcloud kms keyrings list --location global

.PHONY: create-docker-hub-crypto-key
create-docker-hub-crypto-key:
	gcloud kms keys create docker-hub-crypto-key \
	--location global \
	--keyring docker-hub-keyring \
	--purpose=encryption

.PHONY: list-keys
list-keys:
	gcloud kms keys list --location global --keyring docker-hub-keyring

.PHONY: encrypt-docker-hub-password
encrypt-docker-hub-password:
	@gcloud kms encrypt --plaintext-file - \
	--ciphertext-file - \
	--location global \
	--keyring docker-hub-keyring \
	--key docker-hub-crypto-key \
	| base64

DOCKER_USER=

.PHONY: dry-run
dry-run:
	cloud-build-local --config cloudbuild-generated.yaml \
	--substitutions _DOCKERFILE=Dockerfile-openvpn,_DOCKER_USER=${DOCKER_USER} \
	../docker-push

.PHONY: build-local
build-local:
	cloud-build-local --config cloudbuild-generated.yaml \
	--substitutions _DOCKERFILE=Dockerfile-openvpn,_DOCKER_USER=${DOCKER_USER} \
	--dryrun=false ../docker-push
