# 项目 Git 仓库 & 分支
PROJ_GIT_URL=git@github.com:princeofdatamining/project-sample.git
PROJ_GIT_BRANCH=${BRANCH_NAME:-master}
# 镜像名称
IMAGE_NAME=${IMAGE_NAME:-test-djample}
# 项目目录
PROJ_PATH=src
PROJ_TMP="/tmp/${IMAGE_NAME}/$(date +'%s.%N')"

# 处理参数
BLD_MAIN=""; BLD_PYTHON=""; BLD_NUXT=""; BLD_NODE=""; NO_RES="";
while true; do
  case "$1" in
    "." ) PROJ_PATH=$1; echo PROJ_PATH=${PROJ_PATH}; shift ;;
    --path ) PROJ_PATH="$2"; echo PROJ_PATH=${PROJ_PATH}; shift; shift ;;
    --skip-resources ) NO_RES=$1; echo NO_RES=${NO_RES}; shift ;;
    --main ) BLD_MAIN=$1; echo BLD_MAIN=${BLD_MAIN}; shift ;;
    --python ) BLD_PYTHON=$1; echo BLD_PYTHON=${BLD_PYTHON}; shift ;;
    --nuxt ) BLD_NUXT=$1; echo BLD_NUXT=${BLD_NUXT}; shift ;;
    --node ) BLD_NODE=$1; echo BLD_NODE=${BLD_NODE}; shift ;;
    "" ) break ;;
    * ) shift ;;
  esac
done

# 目录不存在则 git clone
[ ! -d ${PROJ_PATH} ] && git clone -q --recursive ${PROJ_GIT_URL} -b ${PROJ_GIT_BRANCH} ${PROJ_PATH}
[ ! "${PROJ_PATH}" == "." ] && cd ${PROJ_PATH}
echo "[0]PWD=`pwd`"; ./scripts/base/00-git-HEAD.sh .GITCOMMIT # git 基本信息：当前提交，父提交, 子模块（可用作“版本”标记）
echo "[1]TMP=${PROJ_TMP}"; mkdir -p "${PROJ_TMP}"; mv .git* ${PROJ_TMP}/; # 暂时移走 git 资源

sed -i "s/PROJ_GIT_DIR=.*/PROJ_GIT_DIR=\/usr\/src\/proj/" scripts/base/environ.sample.rc
sed -i "s/PROJ_PYTHON_VER=.*/PROJ_PYTHON_VER=/" scripts/base/environ.sample.rc
sed -i "s/PROJ_PYTHON_ENV=.*/PROJ_PYTHON_ENV=/" scripts/base/environ.sample.rc
sed -i "s/PROJ_PYTHON_BIN=.*/PROJ_PYTHON_BIN=\/usr\/local\/bin/" scripts/base/environ.sample.rc
#sed -i "s/PROJ_PYTHON=.*/PROJ_PYTHON=\/usr\/local\/bin\/python3/" scripts/base/environ.sample.rc

sed -i "s/STATIC_ROOT=.*/STATIC_ROOT=\${PROJ_GIT_DIR}\/web/" scripts/base/environ.sample.rc
sed -i "s/MEDIA_ROOT=.*/MEDIA_ROOT=\${PROJ_GIT_DIR}\/media/" scripts/base/environ.sample.rc
sed -i "s/PROJ_LOG_DIR=.*/PROJ_LOG_DIR=\${PROJ_GIT_DIR}\/log/" scripts/base/environ.sample.rc

#sed -i "s/ \${PROJ_PYTHON}/ sudo \${PROJ_PYTHON}/" scripts/base/01-submodules.sh
#sed -i "s/^\${PROJ_PIP}/sudo \${PROJ_PIP}/" scripts/base/02-pip.sh
#sed -i "s/^\${PROJ_PIP}/sudo \${PROJ_PIP}/" scripts/dev/02-pip.sh
#sed -i "s/^\${PROJ_PIP}/sudo \${PROJ_PIP}/" scripts/host/02-pip.sh
[ -f "scripts/requirements.txt"      ] && sed -i "s/http\:\/\/git\.dev\.cnicg\.cn\/cnicg\/apps\/django_celery_management/https\:\/\/github.com\/princeofdatamining\/django_celery_management/" scripts/requirements.txt
[ -f "scripts/base/requirements.txt" ] && sed -i "s/http\:\/\/git\.dev\.cnicg\.cn\/cnicg\/apps\/django_celery_management/https\:\/\/github.com\/princeofdatamining\/django_celery_management/" scripts/base/requirements.txt

#sed -i "s/include \/cnicg\/resources.git\/nginx\/gzip\.conf/#include \/path\/to\/gzip\.conf/" scripts/host/19-nginx.sh

sed -i "s/^virtualenv/# virtualenv/" scripts/host/19-uwsgi.sh
sed -i "s/^# pythonpath/pythonpath/" scripts/host/19-uwsgi.sh

build_image() {
    # 替换 src 为目录名，方可保证资源能正确处理
    [ -f ${PROJ_PATH}/scripts/docker/Dockerfile-${1} ] && (\
        cp ${PROJ_PATH}/scripts/docker/Dockerfile-${1} Dockerfile;\
        sed -i "s|^COPY src|COPY `basename ${PROJ_PATH}`|" Dockerfile;\
        docker build -t ${IMAGE_NAME}-${2:-$1} .)
}
[ ! "${PROJ_PATH}" == "." ] && cd .. # 如果非当前目录，需要切换到上层目录 COPY 才会生效
echo "[2]PWD=`pwd`"; # 开始构建镜像
[ -n "${BLD_PYTHON}" ] && build_image python
[ -n "${BLD_NODE}"   ] && build_image node
[ -n "${BLD_NUXT}"   ] && build_image nuxt
[ -n "${BLD_MAIN}"   ] && build_image main gauge

# 移回 git 资源，并清理改动
[ ! "${PROJ_PATH}" == "." ] && cd ${PROJ_PATH}
echo "[3]PWD=`pwd`"; [ -d ${PROJ_TMP} ] && mv ${PROJ_TMP}/.git* ./ && rmdir ${PROJ_TMP}
git reset --hard HEAD
