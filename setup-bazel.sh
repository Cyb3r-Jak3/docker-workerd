#!/bin/bash

case $(uname -m) in
aarch64) ARCH=arm64;;
x86_64) ARCH=x86_64;;
*) echo "Unknown arch" && exit 1;;
esac
wget -qq -O /usr/local/bin/bazel "https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-linux-${ARCH}" && chmod +x /usr/local/bin/bazel