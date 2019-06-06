# 环境变量
. .projrc

# 设定工作目录
cd ${NUXT_WEB_PATH}

# generate config
# cat <<EOF > ...

echo "Updating node_modules ..."
yarn install
PORT=${NUXT_WEB_PORT} npm run build
