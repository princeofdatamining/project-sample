FROM python:3.6

RUN mkdir -p /usr/service/src
WORKDIR /usr/service/src

COPY src ./

RUN rm -rf .git* db
RUN cp scripts/docker/sample.projrc .projrc
RUN bash scripts/base/02-pip.sh
RUN bash scripts/host/02-pip.sh
RUN echo "" > .projrc

EXPOSE 8000

# run as http
CMD [ "python", "manage.py", "runserver", "0.0.0.0:8000" ]
# OR as uwsgi
# CMD [ "uwsgi", "--ini", "/usr/service/conf/uwsgi.ini"]
