FROM quay.io/wikiwatershed/taudem:5.3.8

MAINTAINER Azavea <systems@azavea.com>

ENV RWD_VERSION 1.2.0

RUN mkdir /opt/rwd && \
    wget -qO- https://github.com/WikiWatershed/rapid-watershed-delineation/archive/${RWD_VERSION}.tar.gz \
    | tar -xzC /opt/rwd --strip-components=1 && \
    pip install --no-cache-dir -r /opt/rwd/requirements.txt && \
    pip install --no-cache-dir -r /opt/rwd/src/api/requirements.txt
ENV PYTHONPATH /opt/rwd:$PYTHONPATH

WORKDIR /opt/rwd/src/api
ENTRYPOINT ["gunicorn", "-w", "4", "--log-syslog", "--bind", "0.0.0.0:5000", "main:app"]
