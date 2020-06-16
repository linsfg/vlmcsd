# pre builder
FROM nediiii/alpine as builder

RUN apk add --no-cache curl

WORKDIR /releases
# download latest vlmcsd releases
RUN wget $(curl -s https://api.github.com/repos/Wind4/vlmcsd/releases/latest | grep browser_download_url |tail -n 1 | cut -d '"' -f 4)

RUN tar -zxvf binaries.tar.gz

# main image
FROM nediiii/alpine

LABEL maintainer="nediiii <varnediiii@gmail.com>"

# copy the application
COPY --from=builder /releases/binaries/Linux/intel/static/vlmcsd-x64-musl-static .

EXPOSE 1688

# -L: listen ip:port , -e: log to stdout , -D: run in foreground 
CMD ./vlmcsd-x64-musl-static -L 0.0.0.0:1688 -e -D
