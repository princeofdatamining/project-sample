# 部署文档(standalone)

[TOC]

## 安装工具

```shell
sudo yum install -y wget curl git

# 如需 pyenv 则运行以下两行脚本
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
sudo yum install -y gcc zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel tk-devel libffi-devel
```

## 克隆仓库

1. 指定 GIT 源、版本、下载目录（根据需要自定义）

    ```shell
    cat <<EOF > .gitrc
    # 项目 Git 仓库(本机需要公钥并在 git 服务中登记)
    PROJ_GIT_URL=git@github.com:princeofdatamining/project-sample.git
    # 项目 Git 版本分支
    PROJ_GIT_BRANCH=master
    # 项目 Git 目录(目录、权限依赖于运维或开发规范，不在应用中涉及)
    PROJ_GIT_DIR=/firmcode/teamcode/projcode/src
    EOF
    ```

2. 下载

    ```shell
    cat <<'EOF' | bash
    . .gitrc # 引入环境变量
    
    # 【创建】项目目录(目录、权限依赖于运维或开发规范，不在应用中涉及)
    mkdir -p $PROJ_GIT_DIR
    
    # 【创建】克隆指定版本(请在新的环境上操作，不考虑项目是否存在、是否统一项目)
    git clone --recursive -b $PROJ_GIT_BRANCH $PROJ_GIT_URL $PROJ_GIT_DIR
    
    # .gitrc 移到项目目录下
    mv .gitrc $PROJ_GIT_DIR/
    EOF
    ```

⚠️ 下载完成后， `.gitrc` 文件会移动到项目目录下。

⚠️⚠️ 后续所有操作都需要保证活动目录为 `$PROJ_GIT_DIR`。

## 更新仓库

```shell
# 修改 .gitrc 中的配置项 $PROJ_GIT_BRANCH
bash ./scripts/host/01-git-update.sh
```

## 环境变量(.projrc)

- 编辑 `vi .projrc`（根据需要自定义）

```shell
# 引入其他配置
. .gitrc

# 代号：单位/公司、部门/小组、项目
FIRM_CODE_NAME=firmcode
TEAM_CODE_NAME=teamcode
PROJ_CODE_NAME=projcode
# 项目顶级目录
PROJ_DIR=/$FIRM_CODE_NAME/$TEAM_CODE_NAME/projs/$PROJ_CODE_NAME
# 项目日志目录
PROJ_LOG_DIR=/$FIRM_CODE_NAME/$TEAM_CODE_NAME/log/$PROJ_CODE_NAME
# 服务域名
PROJ_DOMAIN=$PROJ_CODE_NAME.$FIRM_CODE_NAME.com

########################################################
# 使用 pyenv 则需要指定:                               #
#   PROJ_PYTHON_VER, PROJ_PYTHON_ENV, PROJ_PYTHON_DIR; #
# 无需 pyenv 则直接指定:                               #
#   PROJ_PYTHON, PROJ_PIP                              #
########################################################
# python 版本
PROJ_PYTHON_VER=3.6.6
# python 环境
PROJ_PYTHON_ENV=$PROJ_CODE_NAME
# python 路径
PROJ_PYTHON_DIR=/$FIRM_CODE_NAME/app/pyenv/versions/$PROJ_PYTHON_ENV
# python & pip 可执行文件
PROJ_PYTHON=$PROJ_PYTHON_DIR/bin/python
PROJ_PIP=$PROJ_PYTHON_DIR/bin/pip

# 后端静态资源
PROJ_STATIC_URL=/be/static/
PROJ_STATIC_DIR=/$FIRM_CODE_NAME/$TEAM_CODE_NAME/web/$PROJ_CODE_NAME
# 前端静态资源
PROJ_WEB_DIR=$PROJ_GIT_DIR/www/$PROJ_CODE_NAME/dist

# 标识数据库 MySQL 配置
PROJ_MYSQL_ENABLE=False # 是否使用 MySQL
PROJ_MYSQL_DEFAULT=mysql://USERNAME:PASSWORD@HOST:PORT/DBNAME?charset=utf8mb4
PROJ_MYSQL_MODE=STRICT_TRANS_TABLES,NO_AUTO_CREATE_USER,ERROR_FOR_DIVISION_BY_ZERO
PROJ_MYSQL_DRIVER="import pymysql; pymysql.install_as_MySQLdb()"

# raven(sentry)配置
PROJ_RAVEN_DSN=

# 运行服务的帐号
PROJ_USER=maintain

# web 容器(需要配合 nginx 的转发方式)
PROJ_WEB_UPSTREAM=localhost
PROJ_WEB_PORT=8100
PROJ_WEB_PASS=uwsgi_pass
PROJ_WEB_PASS_INCLUDE=uwsgi_params

# uwsgi 配置文件
PROJ_UWSGI_WITH_VENV=\# # 如不需要 virtualenv 则注释掉
PROJ_UWSGI_INI=/$FIRM_CODE_NAME/$TEAM_CODE_NAME/$PROJ_CODE_NAME/uwsgi.ini

# supervisor 配置文件
PROJ_SUPERVISOR_CONF=/$FIRM_CODE_NAME/$TEAM_CODE_NAME/$PROJ_CODE_NAME/supervisor.conf

# nginx 配置文件
PROJ_NGINX_CONF=/$FIRM_CODE_NAME/$TEAM_CODE_NAME/$PROJ_CODE_NAME/nginx.conf
```

## 安装 `pip` 依赖

```shell
# 应用依赖
bash ./scripts/base/02-pip.sh

# 服务依赖(如 uwsgi, supervisor 等)
bash ./scripts/host/02-pip.sh
```
⚠️如需要创建 pyenv 虚拟环境，请先执行：
```shell
bash ./scripts/host/02-pyenv.sh
```

## 初始化项目配置(利用环境变量和模板自动生成)

```shell
bash ./scripts/base/03-environ.sh
```

## 初始化数据（如有需要）

```shell
bash ./scripts/base/10-prepare.sh
```
⚠️如需要处理数据库变更（并有权限），请先执行：
```shell
bash ./scripts/dev/44-migrate.sh
```

## 运行服务

运行容器有两种服务方式: `http` 和 `uwsgi`, `nginx` 也都支持，**两者必须保持一致**。

1. `http`

    ```shell
    bash ./scripts/base/20-runserver.sh
    ```

1. `uwsgi`

    ```shell
    bash ./scripts/host/20-uwsgi.sh
    ```

⚠️初次运行服务前，各服务需要的配置文件：
```shell
bash ./scripts/host/20-service.sh
```
