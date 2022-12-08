FROM alpine:3.17.0
LABEL maintainer="sebastian@sommerfeld.io"

# See https://github.com/cli/cli/blob/trunk/docs/install_linux.md#alpine-linux

# Install from the stable releases' community package repository
# RUN apk add github-cli

# For latest version of the CLI without waiting for the backport into stable release use the edge
# release's community repo, without mixing packages from stable and unstable repos.
RUN echo "@community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add github-cli@community


