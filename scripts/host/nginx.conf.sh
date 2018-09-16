. .projrc && cat <<EOF > $PROJ_NGINX_CONF
server {
  listen 80;
  server_name $PROJ_DOMAIN;
  access_log $PROJ_LOG_DIR/access.log;
  error_log  $PROJ_LOG_DIR/error.log;
  location ~ ^/(api|admin|views)/ {
    $PROJ_WEB_PASS $PROJ_WEB_UPSTREAM:$PROJ_WEB_PORT;
    include $PROJ_WEB_PASS_INCLUDE;
  }
  location $PROJ_STATIC_URL {
    alias $PROJ_STATIC_DIR/;
    expires 5d;
  }
  location / {
    root $PROJ_WEB_DIR;
    index index.html;
    expires 5d;
  }
}
EOF