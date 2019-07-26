# 开发配置文档

如果无法运行 `shell` 脚本，请参考脚本内容自行处理。

## 准备环境配置

```shell
# 复制模板
[ ! -f .projrc ] && cp scripts/base/environ.sample.rc .projrc

# 指定当前目录为项目目录,也可手动设置（编辑 PROJ_GIT_DIR=...）
sed -i "s/PROJ_GIT_DIR=.*/PROJ_GIT_DIR=$(pwd)/" .projrc

vi .projrc

./scripts/flush.sh --no-collect --migrate --no-host
```

如出现错误，修改 `.projrc` 中对应的键值，继续配置。


## 数据库变更(提交 PR 前必须重新合并)

```shell
./scripts/dev/40-makemigrations.sh
```

## 代码检查(提交 PR 前必须自检)

```shell
./scripts/dev/40-pylint.sh
```

## 单元测试(提交 PR 前必须自检)

```shell
./scripts/dev/40-tests.sh
```

## 合并业务、服务依赖(提交 PR 前必须执行)

```shell
./scripts/dev/40-requirements.sh
```

## 合并静态资源(如果项目需要，提交 PR 前必须执行)

```shell
./scripts/flush.sh --no-host
```

## 业务测试(发布前必须通过)

```shell
./scripts/gauges/40-gauge.sh
```

## 运行服务

```shell
./scripts/base/20-runserver.sh
```
