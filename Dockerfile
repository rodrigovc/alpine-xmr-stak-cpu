FROM  alpine:latest
COPY start.sh /tmp/
COPY config.txt /tmp/
RUN   adduser -S -D -H -h /xmr-stak-cpu/bin miner
RUN   chown miner /tmp/config.txt
RUN   apk --no-cache upgrade && \
  apk --no-cache add \
    openssl-dev \
    cmake \
    g++ \
    build-base \
    git && \
  git clone https://github.com/fireice-uk/xmr-stak-cpu && \
  cd xmr-stak-cpu && \
  sed -i 's/constexpr double fDevDonationLevel =.*/constexpr double fDevDonationLevel = 0;/' donate-level.h  && \
  cmake -DMICROHTTPD_REQUIRED=OFF -DCMAKE_LINK_STATIC=ON . && \
  make && \
  apk del \
    cmake \
    g++ \
    build-base \
    git
WORKDIR		/tmp
USER miner
ENTRYPOINT	["./start.sh"]
