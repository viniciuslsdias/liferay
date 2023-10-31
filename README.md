## Code modifications

Inside de code was necessary just add a new route `/healthcheck` to use as a healthcheck, then it was used in liveness and readiness purposes. This app just has dependency of the database and the connection is checked by the TypeORM, then was not necessary create a route to check dependencies and use a Kubernetes startup probe.

## Dockerfile

The Dockerfile strategy was use a multi-stage build to reduce the image size. Furthermore the last step used a scratch node image to also reduce size and improve the security, reducing unnecessary tools and taking care about the container users to avoid admin privileges.

PS: A third-party, not official container image was used in this proccess, it is not a good practice. The right way is create a scratch-node container image to Liferay.

## CI

A CI pipeline was created using github actions to build and push the image to Dockerhub everytime that is a push in main branch.

`.github/workflows/main.yaml`

For deploy a real world application a CD could be made with GitOps, using for example ArgoCD or FluxCD.

In additional is a good practice add tests in this pipeline, unit test, SAST and others.

## Helm Chart

A Helm chart was created to deploy the application, a good practice is keep the Helm Chart in a separeted Git Repository and share it for all applications of the company.

### Secrets

For local development purposes was created a secret that is populated by the helm values.

In real solutions could be used a tool like [External Secrets](https://external-secrets.io/) and keep the secrets in any compatible Vault solution, Secrets Manager, Paramenter Store, Hashicorp Vault and others.

### Topology Spread Constraints

To keep a highly available setup was used spread constraints topology to distrubute the PODs across the AWS AZs. For this local kubernetes Cluster was used hostname to distribute PODs.

Spread constraints is a better solution in this case because is possible distrubute more than one POD in the same AZ, using anti-affinity there is not guarantee.

### Resources (Requests and Limits)

In general, a normal application could has a Burstable QoS, it is used to reduce cost. Instead normal applications, critical Cluster Addons should be keep in guaranteed QoS. For the Liferay app was used a Burstable QoS (requests less than resources).

There are few ways to determine the rights requests and limits, one of them is use VPA to recommend this values. Other way is performe a load test, using K6 or JMeter, and monitor the app resources using for example Prometheus and Grafana.

## Makefile commands

A `Makefile` was created and all the commands are listed below:

| Command                | Description                                     |
|------------------------|-------------------------------------------------|
| `make build`           | Create local docker image.                      |
| `make push`            | Push image to Dockerhub (Login needed).         |
| `make run`             | Run application into local cluster.             |
| `make run/infra`       | Create local Kubernetes Cluster.                |
| `make run/dependencies`| Create Database dependencies into the Cluster.  |
| `make clean/infra`     | Clean local Kubernetes Cluster.                 |

### Common Workflow

`make build` -> `make push` -> `make run/infra` -> `make run/dependencies` -> `make run`

When the local development has been done run `make clean/infra`.

## How to use the API

### Save new Post

```
curl --location 'http://localhost/posts' \
--header 'Content-Type: application/json' \
-H "Host: liferay.local" \
--data '{
    "id": 1,
    "title": "test_1",
    "text": "test_1"
}'
```

### Obtain all Post

```
curl -H "Host: liferay.local" http://localhost/posts
```

### Obtain a specific Post by ID

```
curl -H "Host: liferay.local" http://localhost/posts/1
```

### Healthcheck route

```
curl -H "Host: liferay.local" http://localhost/healthcheck
```