# Docker Workerd

Run [Cloudflare Workerd](https://github.com/cloudflare/workerd) in a docker container.

## Using

With `workerd.capnp` and other worker javascript files in a subdirectory of [`./example`](./example/). Supports both `linux/amd64` and `linux/arm64` architectures.

`docker run --init -p 8080:8080 -v $(pwd)/example:/workerd ghcr.io/cyb3r-jak3/workerd:latest`
