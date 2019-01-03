.PHONY: init
init:
	gcloud init

INSTANCE=openvpn-instance
IMAGE=

.PHONY: create
create:
ifeq (${IMAGE},)
	$(error specify IMAGE)
endif
	gcloud compute instances \
		create-with-container ${INSTANCE} \
		--machine-type=f1-micro \
		--can-ip-forward \
		--tags=https-server \
		--container-image=${IMAGE} \
		--container-arg="--version" \
		--container-privileged \
		--container-restart-policy=never

.PHONY: delete
delete:
	yes | gcloud compute instances delete ${INSTANCE}


host_conf_file=/home/${USER}/server.conf
host_pki_dir=/home/${USER}/pki

.PHONY: upload
upload:
	gcloud compute scp \
		../conf/server.conf ${INSTANCE}:${host_conf_file}
	gcloud compute scp \
		--recurse ../keys/server/pki/. ${INSTANCE}:${host_pki_dir}

.PHONY: docker-run
docker-run:
ifeq (${IMAGE},)
	$(error specify IMAGE)
endif
	gcloud compute ssh ${INSTANCE} --command="docker run -d --rm \
		--name openvpn_server \
		-v ${host_conf_file}:/etc/openvpn/server.conf \
		-v ${host_pki_dir}:/mnt \
		-p 0.0.0.0:443:443/tcp \
		--device /dev/net/tun \
		--cap-add NET_ADMIN \
		${IMAGE} \
		--config /etc/openvpn/server.conf \
	"

.PHONY: docker-ps
docker-ps:
	gcloud compute ssh ${INSTANCE} \
		--command="docker ps"

.PHONY: docker-restart
docker-restart:
ifeq (${IMAGE},)
	$(error specify IMAGE)
endif
	gcloud compute ssh ${INSTANCE} \
		--command="docker image pull ${IMAGE}"
	gcloud compute ssh ${INSTANCE} \
		--command="docker restart openvpn_server"

.PHONY: show-ip
show-ip:
	@gcloud compute instances list \
		--format "value(networkInterfaces[0].accessConfigs[0].natIP)"
