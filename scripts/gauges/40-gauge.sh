# 环境变量
. ./.projrc

. scripts/gauges/gauge.py.sh

# 工作目录
cd ${PROJ_GIT_DIR}/scripts/gauges

# make env ${GAUGE_ENV}
[ -n "${GAUGE_ENV}" ] && [ ! -d env/${GAUGE_ENV} ] && cp -r env/default env/${GAUGE_ENV}
# edit python.properties
${SED:-sed} -i '/GAUGE_PYTHON_COMMAND/d' env/${GAUGE_ENV}/python.properties
echo "GAUGE_PYTHON_COMMAND = ${PROJ_PYTHON}" >> env/${GAUGE_ENV}/python.properties

# copy environ.py
cp ${PROJ_GIT_DIR}/environ/default.py utils/

gauge run --env=${GAUGE_ENV} specs $*
