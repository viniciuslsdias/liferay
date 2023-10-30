SHORT_COMMIT := $$(git rev-parse --short HEAD)

build:
	docker build --ssh default -t "viniciuslsdias/liferay:$(SHORT_COMMIT)" .

push:
	docker push "viniciuslsdias/liferay:$(SHORT_COMMIT)"
	echo -e "\n\nSuccessfully pushed: viniciuslsdias/liferay:$(SHORT_COMMIT)\n\n"
