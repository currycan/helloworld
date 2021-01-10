FROM golang:1.15-buster as builder
RUN set -ex; \
  go env -w GO111MODULE=on; \
  go env -w GOPROXY=https://goproxy.io,direct; \
  go get github.com/ztino/jd_seckill

FROM debian:stable-slim

LABEL MAINTAINER="currycan/helloworld"

ENV TZ Asia/Shanghai

RUN set -ex; \
  ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
  echo $TZ > /etc/timezone; \
  apt-get update && apt-get install -y --no-install-recommends curl; \
  curl -jkSLO https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb; \
  apt install -y ./google-chrome-stable_current_amd64.deb; \
  apt-get install -y --no-install-recommends xorg xvfb gtk2-engines-pixbuf dbus-x11 xfonts-base xfonts-100dpi xfonts-75dpi xfonts-cyrillic xfonts-scalable xvfb; \
  rm -f ./google-chrome-stable_current_amd64.deb; \
  rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/bin/jd_seckill /usr/local/bin/jd_seckill

WORKDIR /app

CMD ["jd_seckill"]
