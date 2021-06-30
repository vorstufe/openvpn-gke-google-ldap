HELM=docker run \
	--rm \
	-u $(shell id -u):$(shell id -g) \
	-v "$(shell pwd):/charts" \
	-w "/charts" \
	alpine/helm:3.6.1

NAMESPACE ?= openvpn

all:
	$(HELM) template . \
		--values=values.yaml \
		--set namespace=${NAMESPACE} \
		> openvpn-gke-google-ldap.yaml

docker:
	docker build -t leanobjects/openvpn:latest .
	docker push leanobjects/openvpn:latest

apply:
	kubectl apply -f openvpn-gke-google-ldap.yaml

#secrets:
#	@ kubectl delete secret -n openvpn google-ldap 2> /dev/null || true
#	@ kubectl delete secret -n openvpn openvpn-certs 2> /dev/null || true
#
#	@ kubectl create secret -n openvpn generic google-ldap \
#		--from-file certificate=google.crt \
#		--from-file key=google.key
#
#	@ kubectl create secret -n openvpn generic openvpn-certs \
#		--from-file server.key=pki/private/server-nopass.key \
#		--from-file ca.crt=pki/ca.crt \
#		--from-file server.crt=pki/issued/server.crt \
#		--from-file dh.pem=pki/dh.pem
