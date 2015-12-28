FROM python:2.7-slim

MAINTAINER Azavea

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    g++ \
    git \
    gfortran \
    libatlas-base-dev \
    libblas-dev \
    libgeos-dev \
    liblapack-dev \
    libopenmpi-dev \
    libtool \
    openmpi-bin \
    python-all-dev \
    python-pip \
    wget

# Install numpy before we build GDAL so that GDAL
# is built with numpy support.
RUN pip install numpy==1.10.1

# Download, build, and install GDAL
RUN cd /usr/local/src && \
    wget -qO- http://download.osgeo.org/gdal/gdal-1.9.0.tar.gz \
    | tar -xz && \
    cd gdal-1.9.0 && \
    ./configure --with-python -with-geos=yes && \
    make && \
    make install

# Download, build, and install PROJ
RUN cd /usr/local/src && \
    wget -qO- http://download.osgeo.org/proj/proj-4.8.0.tar.gz \
    | tar -xz && \
    wget -qO- http://download.osgeo.org/proj/proj-datumgrid-1.5.tar.gz \
    | tar -xzC proj-4.8.0/nad && \
    cd proj-4.8.0 && \
    ./configure && \
    make && \
    make install

# Set env vars
ENV PATH /usr/local/bin:$PATH
ENV CPATH /usr/local/include:/usr/include/gdal:$CPATH
ENV CPLUS_INCLUDE_PATH /usr/include/gdal
ENV C_INCLUDE_PATH /usr/include/gdal
ENV LIBRARY_PATH /usr/local/lib:$LIBRARY_PATH
ENV LD_LIBRARY_PATH /usr/local/lib:$LD_LIBRARY_PATH

# Download and build taudem
# Remove the TestSuite directory because it contains large files
# that we don't need.
RUN mkdir /opt/taudem && \
    wget -qO- https://github.com/dtarb/TauDEM/archive/Develop.tar.gz \
    | tar -xvzC /opt/taudem --strip-components=1 && \
    rm -rf /opt/taudem/TestSuite && \
    cd /opt/taudem/src && make
ENV PATH /opt/taudem/:$PATH

# Download and build RWD
RUN mkdir /opt/rwd/ && \
    wget -qO- https://github.com/WikiWatershed/rapid-watershed-delineation/archive/develop.tar.gz \
    | tar -xzC /opt/rwd --strip-components=1 && \
    cd /opt/rwd && \
    pip install --no-cache-dir -r requirements.txt
