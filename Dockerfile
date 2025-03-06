FROM debian:bookworm-slim

ARG POSTGREST_VERSION=v12.2.8
ARG POSTGREST_FILE=postgrest-${POSTGREST_VERSION}-linux-static-x86-64.tar.xz

RUN mkdir postgrest

WORKDIR /postgrest

ADD https://github.com/PostgREST/postgrest/releases/download/${POSTGREST_VERSION}/${POSTGREST_FILE} .


COPY . /postgrest/

RUN apt-get update && \
    apt-get install -y libpq-dev xz-utils && \
    apt-get install -y gettext-base &&\
    tar xvf ${POSTGREST_FILE} && \
    rm ${POSTGREST_FILE}