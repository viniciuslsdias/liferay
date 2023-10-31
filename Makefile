SHORT_COMMIT := $$(git rev-parse --short HEAD)

build:
	docker build --ssh default -t "viniciuslsdias/liferay:$(SHORT_COMMIT)" .

push:
	docker push "viniciuslsdias/liferay:$(SHORT_COMMIT)"
	echo -e "\n\nSuccessfully pushed: viniciuslsdias/liferay:$(SHORT_COMMIT)\n\n"
run:

	helm upgrade --install liferay ./kubernetes-resources/main-chart --namespace liferay --values=./kubernetes-resources/values-dev.yaml

run/infra:
	kind create cluster --name liferay-development --config ./kubernetes-resources/cluster-config.yaml
	# nginx-ingress controller
	kubectl apply --filename https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/kind/deploy.yaml
	kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=90s

run/dependencies:
	kubectl apply -f ./kubernetes-resources/database.yaml

clean/infra:
	kind delete cluster -n liferay-development

