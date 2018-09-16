# 部署文档(docker)

[TOC]

## 安装工具

```shell
sudo yum install -y wget curl git

curl -fsSL https://get.docker.com/ | sh
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

## 制作镜像

1. 指定 GIT 源、版本、下载目录（根据需要自定义）

    ```shell
    cat <<EOF > .gitrc
    # 项目 Git 仓库
    PROJ_GIT_URL=git@github.com:princeofdatamining/project-sample.git
    # 项目 Git 版本分支
    PROJ_GIT_BRANCH=master
    # 项目 Git 目录
    PROJ_GIT_DIR=/firmcode/teamcode/projcode/src
    EOF
    ```

    ⚠️ 为保证 `Dockerfile` 能直接运行，请保证 `PROJ_GIT_DIR`以 `src` 结束。

1. 下载

    ```shell
    cat <<'EOF' | bash
    . .gitrc # 引入环境变量
    
    # 【创建】下载目录
    mkdir -p $PROJ_GIT_DIR
    
    # 【创建】克隆指定版本
    git clone --recursive -b $PROJ_GIT_BRANCH $PROJ_GIT_URL $PROJ_GIT_DIR
    
    # .gitrc 移到下载目录下
    mv .gitrc $PROJ_GIT_DIR/
    EOF
    ```

    ⚠️ 下载完成后， `.gitrc` 文件会移动到下载目录下。

1. 制作镜像

    ```shell
    # 进入下载目录(`$PROJ_GIT_DIR`)
    bash scripts/docker/build.sh
    ```

## 配置环境

```shell
cat <<'EOF' | bash
# 创建环境目录
PROJ_ENV_DIR=<用于运行环境所需的配置及数据>
IMAGENAME=<镜像名称>

mkdir -p $PROJ_ENV_DIR # 新环境
cd $PROJ_ENV_DIR # 切换到环境
mkdir -p conf db web log # 必备目录

# 从镜像中提取关键文件
docker run --rm -v $PROJ_ENV_DIR:/misc $IMAGENAME cp scripts/docker/docker-compose.yml /misc/
docker run --rm -v $PROJ_ENV_DIR:/misc $IMAGENAME cp scripts/docker/sample.projrc /misc/.projrc
EOF
```

## 辅助脚本

1. 更新框架配置

    > docker-compose run --rm projcode bash scripts/base/03-environ.sh

1. 更新业务配置

    > docker-compose run --rm projcode bash scripts/base/10-prepare.sh

1. 生成 uwsgi、supervisor、nginx 配置（如有需要）

    > docker-compose run --rm projcode bash scripts/host/20-service.sh

1. 数据库变更（如有需要，并拥有数据库高级权限）

    > docker-compose run --rm projcode bash scripts/dev/44-migrate.sh

## 启动服务

> docker-compose up -d
