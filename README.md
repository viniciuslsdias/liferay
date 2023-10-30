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

## How to use

```
curl --location 'localhost/posts' \
--header 'Content-Type: application/json' \
-H "Host: liferay.local" \
--data '{
    "id": 1,
    "title": "test_1",
    "text": "test_1"
}'
```

```
curl -H "Host: liferay.local" http://localhost/posts
```