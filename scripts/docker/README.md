# Docker

## 制作镜像

为了减少 `pip install` 和 `npm i` 的用时，依赖变更时才制作 `IMAGE:python` 镜像：

```shell
scripts/docker/build.sh . [--skip-resources] --python [--gauge] [--skip-image]
```

然后制作 `IMAGE:latest`(或 `IMAGE:gauge`) 镜像：

```
scripts/docker/build.sh . [--skip-resources] [--gauge]
```
