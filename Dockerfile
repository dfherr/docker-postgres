FROM dfherr/ubuntu:16.04
MAINTAINER Dennis-Florian Herr <herrdeflo@gmail.com>

ENV PG_VER 9.6.3
ENV PG_DIR postgresql-$PG_VER
ENV PG_PKG $PG_DIR.tar.bz2

RUN sudo apt-get update -qq -y && \
    sudo apt-get install -y \
    pv \
    libreadline6-dev \
    zlib1g-dev; \
    sudo rm -rf /var/lib/apt/lists/*; \
    sudo rm -rf /var/cache/apt/*;

RUN cd /tmp;                                                        \
    curl -LO http://ftp.postgresql.org/pub/source/v$PG_VER/$PG_PKG; \
    tar xvjf *.tar.bz2; rm -f *.tar.bz2;                            \
    cd $PG_DIR;                                                     \
    ./configure --prefix=/usr/local;                                \
    make world && make install-world;                               \
    cd; rm -rf /tmp/$PG_DIR

RUN sudo useradd -s /bin/bash -m postgres

ADD postgres           /postgres
ADD etc                /usr/local/etc
ADD scripts            /usr/local/scripts

ADD bin/start_postgres /usr/local/bin/start_postgres
RUN sudo chmod 0755 /usr/local/bin/start_postgres

RUN sudo chown postgres: /postgres

RUN echo "postgres ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/postgres
RUN sudo chmod 0440 /etc/sudoers.d/postgres

WORKDIR /home/postgres
ENV     HOME /home/postgres
USER    postgres
EXPOSE  5432
CMD     [ "start_postgres" ]
