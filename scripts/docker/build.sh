# 项目Git仓库
PROJ_GIT_URL=git@git.dev.cnicg.cn:REPO.git
# 项目Git版本分支
PROJ_GIT_BRANCH=gauge
PROJ_VERSION=latest
# 打包文件
PROJ_NAME=src

[ ! -d ${PROJ_NAME} ] && git clone -q --recursive ${PROJ_GIT_URL} -b ${PROJ_GIT_BRANCH} ${PROJ_NAME}

cd ${PROJ_NAME}
rm -rf .git*
rm -rf scripts/deliver/pack* scripts/docker/build*
rm -rf scripts/{allinone.sh,deliver}; [[ ! $@ =~ "--gauge" ]] && rm -rf scripts/{dev,gauges}
rm -rf scripts/host/{00,01}-git*.sh

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
# sed -i "s/include \/cnicg\/resources.git\/nginx\/favicon\.conf/#include \/path\/to\/favicon\.conf/" scripts/host/19-nginx.sh
# sed -i "s/include \/cnicg\/resources.git\/nginx\/robots\.conf/#include \/path\/to\/robots\.conf/" scripts/host/19-nginx.sh
# sed -i "s/include \/cnicg\/resources.git\/nginx\/ssl\.conf/#include \/path\/to\/ssl\.conf/" scripts/host/19-nginx.sh

sed -i "s/^virtualenv/# virtualenv/" scripts/host/19-uwsgi.sh
sed -i "s/^# pythonpath/pythonpath/" scripts/host/19-uwsgi.sh

cd ..
sed -i "s/.*10-prepare.*/# scripts\/base\/10-prepare.sh/" ${PROJ_NAME}/scripts/flush.sh
[ -f ${PROJ_NAME}/scripts/docker/Dockerfile ] && mv ${PROJ_NAME}/scripts/docker/Dockerfile .
if [[ $@ =~ "--gauge" ]]; then
    sed -i -e 1c"FROM getgauge-python" Dockerfile && docker build -t sample-gauges:${PROJ_VERSION} .
else
    sed -i -e 1c"FROM python"          Dockerfile && docker build -t sample:${PROJ_VERSION} .
fi