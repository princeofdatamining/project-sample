PROJ_CODENAME="${PROJ_CODENAME:-djample}"
IMAGE_NAME="${IMAGE_NAME:-test-${PROJ_CODENAME}}"; _IMAGE_NAME_="`echo ${IMAGE_NAME} | sed s/-/_/`"
VERSION=""; if [[ ! $1 == -* ]]; then VERSION="$1"; shift; fi; # 允许指定版本
PROJ_NAME="${PROJ_NAME:-${IMAGE_NAME}}"
RC=/cnicg/projs/${IMAGE_NAME}.rc # 必须准备好配置文件

# 检查最新版本（字典排序）
cd /cnicg/download
if [ -z "${VERSION}" -o "${VERSION}" = "--force" ]; then
    #VERSION=`ls -1r ${IMAGE_NAME}-*.tar.gz | head -n 1 | sed s/\.tar\.gz//g | sed s/${IMAGE_NAME}-//g`
    VERSION=`curl -s http://jumper.maintain.cniotroot.cn/soft/cnicg/find_latest.py | sed "s/#IMAGE_NAME#/${IMAGE_NAME}/" | python | sed s/${IMAGE_NAME}-//g`
elif [ ! -f ${IMAGE_NAME}-${VERSION}.tar.gz ]; then
    echo "Not Found: ${IMAGE_NAME}-${VERSION}.tar.gz" && exit 2
fi
[ -z "${VERSION}" ] && echo "Not Found any archive." && exit 2

# 是否需要解压
FILENAME=/cnicg/download/${IMAGE_NAME}-${VERSION}.tar.gz
DIRNAME=/cnicg/projs/${IMAGE_NAME}-${VERSION}
if [ ! -d ${DIRNAME} ]; then
    echo "unpack ${FILENAME} to ${DIRNAME} ..." && tar -xf ${FILENAME} -C /cnicg/projs
elif [[ $@ =~ "--force" ]]; then
    echo "UNPACK ${FILENAME} to ${DIRNAME} ..." && rm -rf ${DIRNAME} && tar -xf ${FILENAME} -C /cnicg/projs
else
    echo "${DIRNAME} is ready."
fi
rm -f /cnicg/projs/${PROJ_NAME} && ln -s ${DIRNAME} /cnicg/projs/${PROJ_NAME}
cd /cnicg/projs/${PROJ_NAME}

[ ! -f ${RC} ] && cp scripts/base/environ.sample.rc ${RC} && echo "Not Found: ${RC}" && exit 3
cp ${RC} .projrc

# 更新配置、服务
bash scripts/flush.sh $@
command -v supervisorctl >/dev/null && ([ ! -f /cnicg/conf/supervisor/conf.d/${PROJ_NAME}.conf ] && ln -s $(pwd)/scripts/host/supervisor.conf /cnicg/conf/supervisor/conf.d/${PROJ_NAME}.conf;
sudo supervisorctl update && sudo supervisorctl restart ${PROJ_CODENAME}:*)
[ -x /usr/sbin/nginx ]              && ([ ! -f /cnicg/conf/nginx/conf.d/${PROJ_NAME}.conf      ] && ln -s $(pwd)/scripts/host/nginx.conf      /cnicg/conf/nginx/conf.d/${PROJ_NAME}.conf     ;
sudo /usr/sbin/nginx -t && sudo /usr/sbin/nginx -s reload)
echo "Done."
