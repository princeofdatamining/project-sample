# 开发配置文档

如果无法运行 `shell` 脚本，请参考脚本内容自行处理。

## 准备环境配置

> [ ! -f .projrc ] && cp scripts/base/environ.sample.rc .projrc

设定项目目录（编辑第一行 PROJ_GIT_DIR=...），或者执行

```shell
sed -i "s|^PROJ_GIT_DIR=.*|PROJ_GIT_DIR=$(pwd)|" .projrc
```


## 准备 `python` 环境

- 创建新的 pyenv 虚拟环境

  编辑 `.projrc` 中的 `PROJ_PYTHON_VER`、`PROJ_PYTHON_ENV`、`PROJ_PYTHON_BIN`，后调用：

  > ./scripts/flush.sh --no-pip --no-environ --no-prepare --no-host

- python 环境已就绪（无论是否虚拟）

  编辑 `.projrc` 中的 `PROJ_PYTHON`、`PROJ_PIP`


## 安装依赖

> ./scripts/flush.sh --no-environ --no-prepare --no-host

开发环境

> ./scripts/flush.sh --pip-dev --no-pip-host --no-environ --no-prepare --no-host


## 初始化项目配置及数据

自定义 `.projrc` 中其他配置，并执行：

> ./scripts/flush.sh --no-collect --no-host

如出现错误，修改 `.projrc` 中对应的键值，继续配置。

如开发环境需要更新数据库:

> ./scripts/flush.sh --migrate --no-collect --no-host


## 数据库变更(提交 PR 前必须重新合并)

> ./scripts/dev/40-makemigrations.sh


## 代码检查(提交 PR 前必须自检)

> ./scripts/dev/40-pylint.sh


## 单元测试(提交 PR 前必须自检)

> ./scripts/dev/40-tests.sh


## 合并业务、服务依赖(提交 PR 前必须执行)

> ./scripts/dev/40-requirements.sh


## 合并静态资源(如果项目需要，提交 PR 前必须执行)

> ./scripts/flush.sh --no-pyenv --no-pip --no-prepare --no-host


## 业务测试(发布前必须通过)

> ./scripts/gauges/40-gauge.sh


## 运行服务

> ./scripts/base/20-runserver.sh
