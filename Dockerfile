# pre builder
FROM alpine:latest AS builder
# set time and timezone
ENV TZ Asia/Shanghai

RUN apk add --no-cache tzdata && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /root
RUN apk add --no-cache git make build-base && \
    git clone --branch master --single-branch https://github.com/Wind4/vlmcsd.git && \
    cd vlmcsd/ && \
    make

# main image
FROM alpine:latest

LABEL maintainer="acac"

# copy the application
COPY --from=builder /root/vlmcsd/bin/vlmcsd /usr/bin/vlmcsd

EXPOSE 1688

CMD [ "vlmcsd", "-D", "-e" ]
