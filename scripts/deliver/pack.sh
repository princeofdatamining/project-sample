# 项目Git仓库
PROJ_GIT_URL=git@github.com:princeofdatamining/project-sample.git
# 项目Git版本分支
PROJ_GIT_BRANCH=${BRANCH_NAME:-jenkins}
PROJ_VERSION=${PROJ_GIT_BRANCH}-${BUILD_NUMBER:-`date +"%y%m%d%H%M"`}
# 打包文件
IMAGE_NAME=${IMAGE_NAME:-test-djample}
PROJ_NAME=${IMAGE_NAME}-${PROJ_VERSION}

[ ! -d ${PROJ_NAME} -a ! "$1" == "."  ] && git clone -q --recursive ${PROJ_GIT_URL} -b ${PROJ_GIT_BRANCH} ${PROJ_NAME}

[ ! "$1" == "." ] && cd ${PROJ_NAME}
[[ ! $@ =~ "--skip-rm" ]] && (rm -rf .git*;
rm -rf scripts/deliver/pack* scripts/docker/build*;
rm -rf scripts/{ci,dev,docker,gauges,live,allinone.sh};
rm -rf scripts/host/{00,01}-git*.sh Jenkinsfile Dockerfile)

sed -i -e 1c"PROJ_GIT_DIR=/cnicg/projs/${IMAGE_NAME}" scripts/base/environ.sample.rc
sed -i "s/PROJ_PYTHON_VER=.*/PROJ_PYTHON_VER=/" scripts/base/environ.sample.rc
sed -i "s/PROJ_PYTHON_ENV=.*/PROJ_PYTHON_ENV=/" scripts/base/environ.sample.rc
sed -i "s/PROJ_PYTHON_BIN=.*/PROJ_PYTHON_BIN=\/usr\/local\/bin/" scripts/base/environ.sample.rc
sed -i "s/PROJ_PYTHON=.*/PROJ_PYTHON=\/usr\/bin\/python36/" scripts/base/environ.sample.rc

sed -i "s/STATIC_ROOT=.*/STATIC_ROOT=\${PROJ_GIT_DIR}\/web/" scripts/base/environ.sample.rc
sed -i "s/MEDIA_ROOT=.*/MEDIA_ROOT=\/cnicg\/media\/${IMAGE_NAME}/" scripts/base/environ.sample.rc
sed -i "s/PROJ_LOG_DIR=.*/PROJ_LOG_DIR=\/cnicg\/logs\/${IMAGE_NAME}/" scripts/base/environ.sample.rc

sed -i "s/ \${PROJ_PYTHON}/ sudo \${PROJ_PYTHON}/" scripts/base/01-submodules.sh
sed -i "s/^\${PROJ_PIP}/sudo \${PROJ_PIP}/" scripts/base/02-pip.sh
sed -i "s/^\${PROJ_PIP}/sudo \${PROJ_PIP}/" scripts/dev/02-pip.sh
sed -i "s/^\${PROJ_PIP}/sudo \${PROJ_PIP}/" scripts/host/02-pip.sh
[ -f "scripts/requirements.txt"      ] && sed -i "s/http\:\/\/git\.dev\.cnicg\.cn\/cnicg\/apps\/django_celery_management/https\:\/\/github.com\/princeofdatamining\/django_celery_management/" scripts/requirements.txt
[ -f "scripts/base/requirements.txt" ] && sed -i "s/http\:\/\/git\.dev\.cnicg\.cn\/cnicg\/apps\/django_celery_management/https\:\/\/github.com\/princeofdatamining\/django_celery_management/" scripts/base/requirements.txt

sed -i "s/\/resources.git\/nginx\//\/conf\/nginx\/optimize\//" scripts/host/19-nginx.sh

sed -i "s/^virtualenv/# virtualenv/" scripts/host/19-uwsgi.sh
sed -i "s/^# pythonpath/pythonpath/" scripts/host/19-uwsgi.sh

if [ "$1" == "." ]; then
    rm -rf /tmp/${PROJ_NAME}; mkdir /tmp/${PROJ_NAME}; cp -r ./* /tmp/${PROJ_NAME}/; cd /tmp
else
    cd ..
fi
tar -czvf /cnicg/download/${PROJ_NAME}.tar.gz --exclude=*/scripts/ansible --exclude=*.git* ${PROJ_NAME}
echo ${PROJ_NAME}
cd -; rm -rf /tmp/${PROJ_NAME}
#
#
#
#
#
