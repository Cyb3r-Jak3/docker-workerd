FROM python:3-slim-bullseye AS base

ARG BAZEL_VERSION=5.3.1

RUN apt-get update && apt-get install -y --no-install-recommends build-essential ca-certificates wget gnupg git clang libc++-dev libc++abi-dev openjdk-17-jdk 
COPY ./setup-bazel.sh .

RUN bash setup-bazel.sh

RUN git clone https://github.com/cloudflare/workerd.git \
    && cd workerd \
    && bazel build -c opt //src/workerd/server:workerd

RUN apt-get purge --auto-remove -y wget gnupg \
 && rm -rf /etc/apt/sources.list.d/bazel.list \
 && rm -rf /var/lib/apt/lists/*

FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y --no-install-recommends libc++-dev libc++abi-dev

COPY --from=base /workerd/bazel-bin/src/workerd/server/workerd /usr/local/bin/

WORKDIR "/workerd"

ENTRYPOINT [ "workerd" ]

CMD [ "serve", "workerd.capnp" ]