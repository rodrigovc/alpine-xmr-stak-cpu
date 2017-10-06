FROM  ubuntu:16.04
COPY start.sh /tmp/
COPY config.txt /tmp/
RUN   adduser -S -D -H -h /xmr-stak-cpu/bin miner
RUN   chown miner /tmp/config.txt
RUN git clone https://github.com/fireice-uk/xmr-stak-cpu && \
    cd xmr-stak-cpu && \
    sed -i 's/constexpr double fDevDonationLevel =.*/constexpr double fDevDonationLevel = 0;/' donate-level.h  && \
    echo '* soft memlock 262144' >> /etc/security/limits.conf && \
    echo '* hard memlock 262144' >> /etc/security/limits.conf && \
    apt install libmicrohttpd-dev libssl-dev cmake build-essential libhwloc-dev && \
    cmake . && \
    make install
WORKDIR		/tmp
USER miner
ENTRYPOINT	["./start.sh"]
