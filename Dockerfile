FROM ubuntu:latest

RUN apt-get update \
  && apt-get install -y python3-pip python3-dev \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --upgrade pip

WORKDIR /data
ADD . /data

RUN pip install flaskr-1.0.0-py3-none-any.whl

# RUN export FLASK_ENV=development this export won't persist across images (each Dockerfile directive will generate an intermediate container, committed into an intermediate image: that image won't preserve the exported value) but ENV will persist
ENV FLASK_APP flaskr
ENV FLASK_ENV development

# "-m" mod : run library module as a script (terminates option list)
RUN ["python", "-m", "flask", "init-db"] 

ENTRYPOINT ["python"]

# Bind to the 0.0.0.0 IP address for the web server to accept connections originating from outside of the container (instead of 127.0.0.1 which is inside the container)
CMD ["-m", "flask", "run", "-h", "0.0.0.0"] 