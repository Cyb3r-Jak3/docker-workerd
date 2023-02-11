FROM python:3-slim-bullseye AS base


RUN apt-get update && apt-get install -y --no-install-recommends build-essential ca-certificates wget gnupg git clang libc++-dev libc++abi-dev openjdk-17-jdk

ARG BAZEL_VERSION=5.3.0

COPY ./build.sh .

ENV BRANCH=v1.20230209.0

RUN bash build.sh

FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y --no-install-recommends libc++-dev libc++abi-dev && rm -rf /var/lib/apt/lists/*

COPY --from=base /workerd/bazel-bin/src/workerd/server/workerd /usr/local/bin/

WORKDIR "/workerd"

ENTRYPOINT [ "workerd" ]

CMD [ "serve", "workerd.capnp" ]