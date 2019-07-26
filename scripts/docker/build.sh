# 项目Git仓库
PROJ_GIT_URL=git@github.com:princeofdatamining/project-sample.git
# 项目Git版本分支
PROJ_GIT_BRANCH=${BRANCH_NAME:-master}
PROJ_NAME=src
# 打包文件
IMAGE_NAME=${IMAGE_NAME:-test-djample}
IMAGE_SUFFIX=""

NO_RM=""; NO_RES=""; NO_BLD=""; BLD_PYTHON=""; BLD_NODE=""; BLD_NUXT="";
while true; do
  case "$1" in
    "." | "[.]" ) PROJ_NAME="."; echo PROJ_NAME=${PROJ_NAME}; shift ;;
    --gauge | "[--gauge]" ) IMAGE_SUFFIX="-gauge"; echo IMAGE_SUFFIX=${IMAGE_SUFFIX}; shift ;;

    --skip-rm | "[--skip-rm]" ) NO_RM=$1; echo NO_RM=${NO_RM}; shift ;;
    --skip-resources | "[--skip-resources]" ) NO_RES=$1; echo NO_RES=${NO_RES}; shift ;;
    --skip-image | "[--skip-image]" ) NO_BLD=$1; echo NO_BLD=${NO_BLD}; shift ;;

    --python | "[--python]" ) BLD_PYTHON=$1; echo BLD_PYTHON=${BLD_PYTHON}; shift ;;
    --node | "[--node]" ) BLD_NODE=$1; echo BLD_NODE=${BLD_NODE}; shift ;;
    --nuxt | "[--nuxt]" ) BLD_NUXT=$1; echo BLD_NUXT=${BLD_NUXT}; shift ;;
    * ) break ;;
  esac
done

[ ! -d ${PROJ_NAME} ] && git clone -q --recursive ${PROJ_GIT_URL} -b ${PROJ_GIT_BRANCH} ${PROJ_NAME}
[ ! "${PROJ_NAME}" == "." ] && cd ${PROJ_NAME}

[ -z "${NO_RM}" ] && ([ -d /tmp/${IMAGE_NAME} ] && rm -rf /tmp/${IMAGE_NAME}; mkdir /tmp/${IMAGE_NAME}; mv .git* /tmp/${IMAGE_NAME}/;\
rm -rf scripts/deliver/pack* scripts/docker/build*;\
rm -rf scripts/{ansible,deliver}; [ -z "${IMAGE_SUFFIX}" ] && rm -rf scripts/{dev,gauges};\
rm -rf scripts/host/{00,01}-git*.sh)

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

[ ! "${PROJ_NAME}" == "." ] && cd ..
[ -n "${BLD_PYTHON}" ] && [ -f ${PROJ_NAME}/scripts/docker/Dockerfile-python ] && (\
    cp ${PROJ_NAME}/scripts/docker/Dockerfile-python Dockerfile; sed -i "s/^COPY src/COPY ${PROJ_NAME}/" Dockerfile;\
    docker build -t ${IMAGE_NAME}-python .)
[ -n "${BLD_NODE}" ] && [ -f ${PROJ_NAME}/scripts/docker/Dockerfile-node ] && (\
    cp ${PROJ_NAME}/scripts/docker/Dockerfile-node Dockerfile; sed -i "s/^COPY src/COPY ${PROJ_NAME}/" Dockerfile;\
    docker build -t ${IMAGE_NAME}-node .)
[ -n "${BLD_NUXT}" ] && [ -f ${PROJ_NAME}/scripts/docker/Dockerfile-nuxt ] && (\
    cp ${PROJ_NAME}/scripts/docker/Dockerfile-nuxt Dockerfile; sed -i "s/^COPY src/COPY ${PROJ_NAME}/" Dockerfile;\
    docker build -t ${IMAGE_NAME}-nuxt .)
[ -z "${NO_BLD}" ] && [ -f ${PROJ_NAME}/scripts/docker/Dockerfile ] && (\
    cp ${PROJ_NAME}/scripts/docker/Dockerfile .; sed -i "s/^COPY src/COPY ${PROJ_NAME}/" Dockerfile;\
    docker build -t ${IMAGE_NAME}${IMAGE_SUFFIX} .)

[ ! "${PROJ_NAME}" == "." ] && cd ${PROJ_NAME}
[ -z "${NO_RM}" ] && [ -d /tmp/${IMAGE_NAME} ] && mv /tmp/${IMAGE_NAME}/.git* ./
git reset --hard HEAD
