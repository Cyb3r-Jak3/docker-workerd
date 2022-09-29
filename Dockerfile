FROM python:3-slim-bullseye AS base

ENV BAZEL_VERSION 5.3.0

# Creating the man pages directory to deal with the slim variants not having it.
RUN apt-get update && apt-get install -y --no-install-recommends build-essential ca-certificates curl gnupg git clang libc++-dev libc++abi-dev

RUN echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" > \
         /etc/apt/sources.list.d/bazel.list \
    && curl https://bazel.build/bazel-release.pub.gpg | apt-key add - && \
    apt-get update

RUN apt-get install -y --no-install-recommends bazel=${BAZEL_VERSION} 

RUN apt-get purge --auto-remove -y curl gnupg \
 && rm -rf /etc/apt/sources.list.d/bazel.list \
 && rm -rf /var/lib/apt/lists/*

FROM base

RUN git clone https://github.com/cloudflare/workerd.git \
    && cd workerd \
    && bazel build -c opt //src/workerd/server:workerd
