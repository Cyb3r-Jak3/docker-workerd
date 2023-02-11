#!/bin/bash

case $(uname -m) in
aarch64) ARCH=arm64;;
x86_64) ARCH=x86_64;;
*) echo "Unknown arch" && exit 1;;
esac
wget -qq -O /usr/local/bin/bazel "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-${ARCH}" && chmod +x /usr/local/bin/bazel


isSet() {
    [ -z "${1}" ]
}

if isSet "${BRANCH}"; then
    echo "Missing BRANCH"
    exit 1
fi

git clone --single-branch --depth 1 --branch "${BRANCH}" https://github.com/cloudflare/workerd.git
cd workerd || exit 1
bazel build -c opt //src/workerd/server:workerd