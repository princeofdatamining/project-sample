# 项目Git仓库
PROJ_GIT_URL=git@github.com:princeofdatamining/project-sample.git
# 项目Git版本分支
PROJ_GIT_BRANCH=${BRANCH_NAME:-master}
PROJ_VERSION=latest; if [[ $@ =~ "--gauge" ]]; then PROJ_VERSION="gauge"; fi;
# 打包文件
IMAGE_NAME=${IMAGE_NAME:-test-djample}
PROJ_NAME=src; if [ "$1" == "." ]; then PROJ_NAME="."; fi;

[ ! -d ${PROJ_NAME} ] && git clone -q --recursive ${PROJ_GIT_URL} -b ${PROJ_GIT_BRANCH} ${PROJ_NAME}

[ ! "$1" == "." ] && cd ${PROJ_NAME}
[[ ! $@ =~ "--skip-rm" ]] && (rm -rf .git*;\
rm -rf scripts/deliver/pack* scripts/docker/build*;\
rm -rf scripts/{allinone.sh,deliver}; [[ ! $@ =~ "--gauge" ]] && rm -rf scripts/{dev,gauges};\
rm -rf scripts/host/{00,01}-git*.sh)

sed -i -e 1c"PROJ_GIT_DIR=/usr/src/proj" scripts/base/environ.sample.rc
sed -i "s/PROJ_PYTHON_VER=.*/PROJ_PYTHON_VER=/" scripts/base/environ.sample.rc
sed -i "s/PROJ_PYTHON_ENV=.*/PROJ_PYTHON_ENV=/" scripts/base/environ.sample.rc
sed -i "s/PROJ_PYTHON_BIN=.*/PROJ_PYTHON_BIN=\/usr\/local\/bin/" scripts/base/environ.sample.rc
# sed -i "s/PROJ_PYTHON=.*/PROJ_PYTHON=\/usr\/local\/bin\/python3/" scripts/base/environ.sample.rc

sed -i "s/STATIC_ROOT=.*/STATIC_ROOT=\${PROJ_GIT_DIR}\/web/" scripts/base/environ.sample.rc
sed -i "s/MEDIA_ROOT=.*/MEDIA_ROOT=\${PROJ_GIT_DIR}\/media/" scripts/base/environ.sample.rc
sed -i "s/PROJ_LOG_DIR=.*/PROJ_LOG_DIR=\${PROJ_GIT_DIR}\/log/" scripts/base/environ.sample.rc

# sed -i "s/; \${PROJ_PYTHON}/; sudo \${PROJ_PYTHON}/" scripts/base/01-submodules.sh
# sed -i "s/^\${PROJ_PIP}/sudo \${PROJ_PIP}/" scripts/base/02-pip.sh
# sed -i "s/^\${PROJ_PIP}/sudo \${PROJ_PIP}/" scripts/dev/02-pip.sh
# sed -i "s/^\${PROJ_PIP}/sudo \${PROJ_PIP}/" scripts/host/02-pip.sh
[ -f "scripts/requirements.txt"      ] && sed -i "s/http\:\/\/git\.dev\.cnicg\.cn\/cnicg\/apps\/django_celery_management/https\:\/\/github.com\/princeofdatamining\/django_celery_management/" scripts/requirements.txt
[ -f "scripts/base/requirements.txt" ] && sed -i "s/http\:\/\/git\.dev\.cnicg\.cn\/cnicg\/apps\/django_celery_management/https\:\/\/github.com\/princeofdatamining\/django_celery_management/" scripts/base/requirements.txt

# sed -i "s/include \/cnicg\/resources.git\/nginx\/gzip\.conf/#include \/path\/to\/gzip\.conf/" scripts/host/19-nginx.sh

sed -i "s/^virtualenv/# virtualenv/" scripts/host/19-uwsgi.sh
sed -i "s/^# pythonpath/pythonpath/" scripts/host/19-uwsgi.sh

[ ! "$1" == "." ] && cd ..
[[ $@ =~ "--python" ]] && [ -f ${PROJ_NAME}/scripts/docker/Dockerfile-python ] && (\
    cp ${PROJ_NAME}/scripts/docker/Dockerfile-python Dockerfile; sed -i "s/^COPY src/COPY ${PROJ_NAME}/" Dockerfile;\
    docker build -t ${IMAGE_NAME}:python .)
[[ $@ =~ "--node" ]] && [ -f ${PROJ_NAME}/scripts/docker/Dockerfile-node ] && (\
    cp ${PROJ_NAME}/scripts/docker/Dockerfile-node Dockerfile; sed -i "s/^COPY src/COPY ${PROJ_NAME}/" Dockerfile;\
    docker build -t ${IMAGE_NAME}:node .)
[[ $@ =~ "--nuxt" ]] && [ -f ${PROJ_NAME}/scripts/docker/Dockerfile-nuxt ] && (\
    cp ${PROJ_NAME}/scripts/docker/Dockerfile-nuxt Dockerfile; sed -i "s/^COPY src/COPY ${PROJ_NAME}/" Dockerfile;\
    docker build -t ${IMAGE_NAME}:nuxt .)
[[ ! $@ =~ "--skip-image" ]] && [ -f ${PROJ_NAME}/scripts/docker/Dockerfile ] && (\
    cp ${PROJ_NAME}/scripts/docker/Dockerfile .; sed -i "s/^COPY src/COPY ${PROJ_NAME}/" Dockerfile;\
    docker build -t ${IMAGE_NAME}:${PROJ_VERSION} .)
