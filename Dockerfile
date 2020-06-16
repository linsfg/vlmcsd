# pre builder
FROM alpine:latest AS builder

RUN apk add --no-cache curl
EXPOSE 1688
CMD [ "vlmcsd", "-D", "-e" ]

WORKDIR /releases
# download latest vlmcsd releases
RUN wget $(curl -s https://api.github.com/repos/Wind4/vlmcsd/releases/latest | grep browser_download_url |tail -n 1 | cut -d '"' -f 4)

RUN tar -zxvf binaries.tar.gz

# main image
FROM alpine:latest

LABEL maintainer="nediiii <varnediiii@gmail.com>"

# copy the application
COPY --from=builder /root/vlmcsd/bin/vlmcsd /usr/bin/vlmcsd

EXPOSE 1688

# -L: listen ip:port , -e: log to stdout , -D: run in foreground 
#CMD ./vlmcsd-x64-musl-static -L 0.0.0.0:1688 -e -D
CMD [ "vlmcsd", "-D", "-e" ]
