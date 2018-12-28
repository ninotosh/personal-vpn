.PHONY: generate-keys
generate-keys:
	./generate-keys.sh

.PHONY: kubectl-show-server-ip
kubectl-show-server-ip:
	kubectl get service openvpn-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
	@echo

SERVER=
.PHONY: generate-ovpn
generate-ovpn:
ifeq (${SERVER},)
	$(error specify SERVER)
endif
	./generate-ovpn.sh ${SERVER}
