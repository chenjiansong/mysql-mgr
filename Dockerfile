FROM mysql:5.7.27
MAINTAINER Ku8Manager <ku8manager@hpe.com>

# set timezone
ENV TZ Asia/Shanghai

# Set TERM env to avoid mysql client error message "TERM environment variable not set" when running from inside the container
ENV TERM xterm

# install percona-xtrabackup
RUN apt-get update -y && apt-get install -y wget lsb-release vim curl net-tools openssh-client \
    && wget https://repo.percona.com/apt/percona-release_0.1-4.$(lsb_release -sc)_all.deb \
    && dpkg -i percona-release_0.1-4.$(lsb_release -sc)_all.deb \
    && apt-get update -y && apt-get install -y --force-yes percona-xtrabackup-24 && apt-get install -y pmm-client \
    && apt-get install -y procps percona-toolkit \
    && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# xtrabackup scripts: to backup mysql data to other storage, e.g. glusterfs
COPY xtrabackup /home/xtrabackup
RUN chmod -R 755 /home/xtrabackup

ENV XTRABACKUP_PATH "/home/xtrabackup/cron/bin"

# customized container startup script
COPY run.sh /run.sh
RUN chmod 755 /run.sh

ENTRYPOINT ["/run.sh"]
CMD ["mysqld"]
