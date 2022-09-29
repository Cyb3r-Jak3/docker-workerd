FROM python:3-slim-bullseye AS base

ENV BAZEL_VERSION 5.3.0

RUN apt-get update && apt-get install -y --no-install-recommends build-essential ca-certificates curl gnupg git clang libc++-dev libc++abi-dev apt-transport-https

RUN curl -fsSL https://bazel.build/bazel-release.pub.gpg | gpg --dearmor > /usr/share/keyrings/bazel-archive-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8" > /etc/apt/sources.list.d/bazel.list \
    && apt-get update

RUN apt-get install -y --no-install-recommends bazel=${BAZEL_VERSION} 

RUN git clone https://github.com/cloudflare/workerd.git \
    && cd workerd \
    && bazel build -c opt //src/workerd/server:workerd

RUN apt-get purge --auto-remove -y curl gnupg \
 && rm -rf /etc/apt/sources.list.d/bazel.list \
 && rm -rf /var/lib/apt/lists/*

FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y --no-install-recommends libc++-dev libc++abi-dev

COPY --from=base /workerd/bazel-bin/src/workerd/server/workerd /usr/local/bin/

WORKDIR "/workerd"

ENTRYPOINT [ "workerd" ]

CMD [ "serve", "workerd.capnp" ]