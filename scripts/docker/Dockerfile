FROM python

# 工作目录
RUN mkdir -p /usr/src/proj
WORKDIR /usr/src/proj
COPY src ./

# pip
RUN mkdir ~/.pip
RUN mv scripts/host/pip.aliyun.conf ~/.pip/pip.conf
RUN if [ -f scripts/dev/requirements.txt ]; then pip3 install -q -r scripts/dev/requirements.txt; fi

# 初始化环境
RUN cp scripts/base/environ.sample.rc .projrc
RUN bash scripts/flush.sh

EXPOSE 8000

# run as http(proxy_pass on nginx)
# CMD [ "python", "manage.py", "runserver", "0.0.0.0:8000" ]
# OR as uwsgi(uwsgi_pass on nginx)
CMD [ "uwsgi", "--ini", "scripts/host/uwsgi.ini" ]
