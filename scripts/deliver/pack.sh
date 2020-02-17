# 项目Git仓库
PROJ_GIT_URL=git@github.com:princeofdatamining/project-sample.git
# 项目Git版本分支
PROJ_GIT_BRANCH=${BRANCH_NAME:-build}
PROJ_VERSION=${PROJ_GIT_BRANCH}-${BUILD_NUMBER:-`date +"%y%m%d%H%M"`}
# 打包文件
IMAGE_NAME=${IMAGE_NAME:-test-djample}
PROJ_NAME=${IMAGE_NAME}-${PROJ_VERSION}

USE_PWD="";
while true; do
  case "$1" in
    "." ) USE_PWD=$1; echo USE_PWD=${USE_PWD}; shift ;; # 使用当前目录
    # 其他参数
    "" ) break ;;
    * ) shift ;;
  esac
done

ORIG_PWD="`pwd`"; echo "[0] PWD=`pwd`"
if [ -n "${USE_PWD}" ]; then
    # 当前目录名不一定是完整名称，创建一个临时目录来保证
    PROJ_PATH="/tmp/${IMAGE_NAME}/${PROJ_NAME}";
    rm -rf "${PROJ_PATH}"; mkdir -p `dirname "${PROJ_PATH}"`; cp -r `pwd` "${PROJ_PATH}"
else
    # 使用完整名称作为目录名，如果目录不存在 git clone
    PROJ_PATH="${PROJ_NAME}";
    [ ! -d ${PROJ_PATH} ] && git clone -q --recursive ${PROJ_GIT_URL} -b ${PROJ_GIT_BRANCH} ${PROJ_PATH}
fi

cd ${PROJ_PATH}; echo "[1] PWD=`pwd`";
./scripts/base/00-git-HEAD.sh GITHEAD.txt # git 基本信息：当前提交，父提交, 子模块（可用作“版本”标记）

#sed -i "s/PROJ_WEB_PORT=.*/PROJ_WEB_PORT=8000/" scripts/base/environ.sample.rc
#sed -i "s/PROJ_GRPC_PORT=.*/PROJ_GRPC_PORT=8002/" scripts/base/environ.sample.rc
#
#

sed -i "s/PROJ_GIT_DIR=.*/PROJ_GIT_DIR=\/cnicg\/projs\/${IMAGE_NAME}/" scripts/base/environ.sample.rc
#sed -i "s/PROJ_PYTHON_VER=.*/PROJ_PYTHON_VER=/" scripts/base/environ.sample.rc
#sed -i "s/PROJ_PYTHON_ENV=.*/PROJ_PYTHON_ENV=/" scripts/base/environ.sample.rc
#sed -i "s/PROJ_PYTHON_BIN=.*/PROJ_PYTHON_BIN=\/usr\/local\/bin/" scripts/base/environ.sample.rc
#sed -i "s/PROJ_PYTHON=.*/PROJ_PYTHON=\/usr\/bin\/python36/" scripts/base/environ.sample.rc

sed -i "s/STATIC_ROOT=.*/STATIC_ROOT=\${PROJ_GIT_DIR}\/web/" scripts/base/environ.sample.rc
#sed -i "s/MEDIA_ROOT=.*/MEDIA_ROOT=\/cnicg\/media\/${IMAGE_NAME}/" scripts/base/environ.sample.rc
#sed -i "s/PROJ_LOG_DIR=.*/PROJ_LOG_DIR=\/cnicg\/logs\/${IMAGE_NAME}/" scripts/base/environ.sample.rc

#sed -i "s/ \${PROJ_PYTHON}/ sudo \${PROJ_PYTHON}/" scripts/base/01-submodules.sh
#sed -i "s/^\${PROJ_PIP}/sudo \${PROJ_PIP}/" scripts/base/02-pip.sh
#sed -i "s/^\${PROJ_PIP}/sudo \${PROJ_PIP}/" scripts/dev/02-pip.sh
#sed -i "s/^\${PROJ_PIP}/sudo \${PROJ_PIP}/" scripts/host/02-pip.sh
[ -f "scripts/requirements.txt"      ] && sed -i "s/http\:\/\/git\.dev\.cnicg\.cn\/cnicg\/apps\/django_celery_management/https\:\/\/github.com\/princeofdatamining\/django_celery_management/" scripts/requirements.txt
[ -f "scripts/base/requirements.txt" ] && sed -i "s/http\:\/\/git\.dev\.cnicg\.cn\/cnicg\/apps\/django_celery_management/https\:\/\/github.com\/princeofdatamining\/django_celery_management/" scripts/base/requirements.txt

#sed -i "s/\/resources.git\/nginx\//\/conf\/nginx\/optimize\//" scripts/host/19-nginx.sh

#sed -i "s/^virtualenv/# virtualenv/" scripts/host/19-uwsgi.sh
#sed -i "s/^# pythonpath/pythonpath/" scripts/host/19-uwsgi.sh

# 初始化各种配置
# cd www/admin/dist/static && ([ -f config.js.sample -a ! -f config.js] && cp config.js.sample config.js) && cd -
# 
#
#

# 清除前端原始代码
# mv www/admin/dist www/admin_dist; rm -rf www/admin; mv www/admin_dist www/admin;
# mv www/default/dist www/default_dist; rm -rf www/default; mv www/default_dist www/default;
#
#

cd ..; echo "[2] PWD=`pwd`";
# 回到上级目录，制作的压缩文件重新解压会使用完整名称(项目名称-版本-build-序号)作为默认目录
tar -czf /cnicg/download/${PROJ_NAME}.tar.gz \
  --exclude-vcs --exclude=*/scripts/00* \
  --exclude=*/scripts/{ci,deliver,dev,docker,gauges,live} \
  --exclude={Jenkinsfile,Dockerfile} \
  ${PROJ_NAME}

# 清理临时目录，回到原始目录
if [ -n "${USE_PWD}" ]; then rm -rf "${PROJ_PATH}"; fi
cd "${ORIG_PWD}"; echo "[3] PWD=`pwd`";
