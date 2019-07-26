# 部署/开发文档

## 脚本说明

- `.gitrc` 代码仓库配置

- `.projrc` 项目环境配置

- `scripts/base/` # 业务相关脚本

  | 脚本                | 说明                           |
  | ------------------- | ------------------------------ |
  | `01-submodules.sh`  | 以 `python setup.py --develop` 方式注册子模块依赖 |
  | `02-pip.sh`         | 安装业务功能所需依赖           |
  | `03-environ.sh`     | 生成项目环境配置               |
  | `10-prepare.sh`     | 预处理数据                     |
  | `20-runserver.sh`   | 以 `django runserver` 启动服务 |
  | `environ.py.sh`     | `Django` 项目环境配置模板      |
  | `environ.sample.rc` | 环境变量配置模板               |
  | `requirements.txt`  | 业务功能所需依赖               |

- `scripts/deliver/` # 交付相关脚本

  | 脚本          | 说明                             |
  | ------------- | -------------------------------- |
  | `deploy.sh`   | 部署/更新脚本                    |
  | `pack.sh`     | 交付打包脚本                     |

- `scripts/dev/` # 开发相关，与发布无关

  | 脚本                   | 说明                                              |
  | ---------------------- | ------------------------------------------------- |
  | `02-pip.sh`            | 安装开发所需依赖                                  |
  | `40-makemigrations.sh` | 数据库变更(提交 PR 前必须重新合并)                |
  | `40-pylint.sh`         | 语法检查（提交前检查）                            |
  | `40-requirements.sh`   | 合并业务、运行所需依赖（可选，提交前检查）        |
  | `40-tests.sh`          | 单元测试（提交前处理）                            |
  | `env.sh`               | `pyenv` 环境下，无需激活(activate)相关环境        |
  | `manage.sh`            | `pyenv` 环境下，无需激活(activate)相关环境        |
  | `requirements.txt`     | 开发所需依赖                                      |

- `scripts/docker/` # docker 相关脚本

- `scripts/gauges/` # gauge 接口测试工程

- `scripts/host/` # 服务相关脚本

  | 脚本               | 说明                                                   |
  | ------------------ | ------------------------------------------------------ |
  | `00-git-clone.sh`  | 仅用于克隆项目，需要准备 `.gitrc` & `.projrc` 配置文件 |
  | `01-git-update.sh` | 更新到指定分支                                         |
  | `02-pip.sh`        | 安装服务运行所需依赖                                   |
  | `02-pyenv.sh`      | 安装 pyenv 虚拟环境（可配、可选）                      |
  | `19-nginx.sh`      | 生成 nginx include 配置                                |
  | `19-nuxt.sh`       | 编译 nuxt                                              |
  | `19-supervisor.sh` | 生成 supervisor include 配置                           |
  | `19-uwsgi.sh`      | 生成 uwsgi 配置                                        |
  | `20-runserver.sh`  | 以自定义方式启动服务: `uwsgi`, `gunicorn`, ...         |
  | `requirements.txt` | 服务运行所需依赖                                       |
