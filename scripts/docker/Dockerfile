FROM test-djample-python:b1

# 工作目录
RUN mkdir -p /usr/src/proj
WORKDIR /usr/src/proj
COPY src ./
RUN rm -rf Dockerfile Jenkinsfile scripts/docker

# 初始化环境
RUN cp scripts/base/environ.sample.rc .projrc
RUN bash scripts/flush.sh --no-prepare --no-nuxt

EXPOSE 8000

# run as http(proxy_pass on nginx)
# CMD [ "python", "manage.py", "runserver", "0.0.0.0:8000" ]
# OR as uwsgi(uwsgi_pass on nginx)
CMD [ "uwsgi", "--ini", "scripts/host/uwsgi.ini" ]
