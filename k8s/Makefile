.PHONY: up
up: apply-secret apply-configmap apply-service

.PHONY: down
down: delete-service delete-configmap delete-secret

.PHONY: apply-secret
apply-secret:
	./apply-secret.sh

.PHONY: delete-secret
delete-secret:
	-kubectl delete secret pki-secret

.PHONY: apply-configmap
apply-configmap:
	./apply-configmap.sh

.PHONY: delete-configmap
delete-configmap:
	-kubectl delete configmap server-configmap

.PHONY: apply-service
apply-service:
	./apply-service.sh

.PHONY: delete-service
delete-service:
	-kubectl delete -f openvpn.yaml

.PHONY: get-pod
get-pod:
	-kubectl get pod
