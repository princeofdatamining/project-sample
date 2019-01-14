cat <<EOF > scripts/host/nginx.conf
server {
  listen 80;
  server_name ${PROJ_DOMAIN};
  access_log ${PROJ_LOG_DIR}/access.log;
  error_log  ${PROJ_LOG_DIR}/error.log;
  location ~ ^/api/[^/]+\.js(on)?$ {
    root ${STATIC_ROOT}/ssr/;
    expires 1d;
    include /cnicg/resources.git/nginx/gzip.conf;
  }
  location ~ ^/(admin|api|views)/ {
    uwsgi_pass 127.0.0.1:${PROJ_WEB_PORT};
    include uwsgi_params;
  }
  location ${STATIC_URL} {
    alias ${STATIC_ROOT}/;
    expires 5d;
    include /cnicg/resources.git/nginx/gzip.conf;
  }
  location / {
    root ${PUB_WWW_ROOT}/;
    expires 5d;
    include /cnicg/resources.git/nginx/gzip.conf;
  }
  include /cnicg/resources.git/nginx/favicon.conf;
  include /cnicg/resources.git/nginx/robots.conf;
  include /cnicg/resources.git/nginx/ssl.conf;
}
EOF