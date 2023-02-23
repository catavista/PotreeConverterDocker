# build environment 
FROM alpine:latest

ARG VERSION=latest
LABEL Name="potree-converter ${VERSION}"
LABEL Maintainer="Thomas Tran"

# set the working directory for potree converter build
WORKDIR /potreeconverterbuild

# install required libs
RUN apk add --no-cache git cmake make gcc g++ libtbb-dev tar

# clone and compile potree converter
RUN git clone --depth 1 https://github.com/catavista/PotreeConverter /PotreeConverter 
RUN mkdir -p /data/input /data/output
RUN cmake /PotreeConverter && make

# delete unused stuffs
RUN apk del git cmake make gcc g++ && \
    rm -rf /PotreeConverter

# copy entry point s
COPY ./entrypoint.sh ./
ENV POTREE_ENCODING=UNCOMPRESSED \
    POTREE_METHOD=poisson \
    POTREE_EXTRA_OPTIONS="" \
    OVERWRITE=TRUE \
    REMOVE_INDEX=FALSE
ENTRYPOINT exec ./entrypoint.sh
