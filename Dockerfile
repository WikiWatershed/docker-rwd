FROM ubuntu:14.04

MAINTAINER Azavea <systems@azavea.com>

ENV GDAL_VERSION 1.11.0
ENV OPEN_MPI_SHORT_VERSION 1.8
ENV OPEN_MPI_VERSION 1.8.1
ENV TAUDEM_VERSION 5.3.7
ENV RWD_VERSION 1.1.0

RUN apt-get update && apt-get install -y \
    build-essential \
    g++ \
    gfortran \
    python-all-dev \
    python-pip \
    python-numpy \
    libblas-dev \
    liblapack-dev \
    libgeos-dev \
    libproj-dev \
    libspatialite-dev \
    libspatialite5 \
    spatialite-bin \
    libibnetdisc-dev \
    wget

RUN wget -qO- http://download.osgeo.org/gdal/${GDAL_VERSION}/gdal-${GDAL_VERSION}.tar.gz \
    | tar -xzC /usr/src \
    && cd /usr/src/gdal-${GDAL_VERSION} \
    && ./configure --with-python --with-spatialite \
    && make install

RUN wget -qO- https://www.open-mpi.org/software/ompi/v${OPEN_MPI_SHORT_VERSION}/downloads/openmpi-${OPEN_MPI_VERSION}.tar.gz \
    | tar -xzC /usr/src \
    && cd /usr/src/openmpi-${OPEN_MPI_VERSION} \
    && ./configure \
    && make install \
    && ldconfig

# Download and build taudem
# The release tags start with "v" but the folder inside the archive doesn't.
RUN wget -qO- https://github.com/dtarb/TauDEM/archive/v${TAUDEM_VERSION}.tar.gz \
    | tar -xzC /usr/src \
    # Remove the TestSuite directory because it contains large files
    # that we don't need.
    && rm -rf /usr/src/TauDEM-${TAUDEM_VERSION}/TestSuite \
    && cd /usr/src/TauDEM-${TAUDEM_VERSION}/src \
    && make
RUN ln -s /usr/src/TauDEM-${TAUDEM_VERSION} /opt/taudem
ENV PATH /opt/taudem:$PATH

RUN pip install --upgrade pip

# Download and build RWD
# The SHA in the following URL should be kept in sync with the latest commit on
# the develop branch. If we simply used develop.tar.gz, this command would
# not be executed (due to the cache) and we would not get the latest commits.
# See https://ryanfb.github.io/etc/2015/07/29/git_strategies_for_docker.html#dockerfile-inside-git-repository
RUN mkdir /opt/rwd && \
    wget -qO- https://github.com/WikiWatershed/rapid-watershed-delineation/archive/${RWD_VERSION}.tar.gz \
    | tar -xzC /opt/rwd --strip-components=1 && \
    pip install --no-cache-dir -r /opt/rwd/requirements.txt && \
    pip install --no-cache-dir -r /opt/rwd/src/api/requirements.txt
ENV PYTHONPATH /opt/rwd:$PYTHONPATH

WORKDIR /opt/rwd/src/api
ENTRYPOINT ["gunicorn", "-w", "4", "--log-syslog", "--bind", "0.0.0.0:5000", "main:app"]
