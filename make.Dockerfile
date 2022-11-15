################################################
#
#  Python 3.7.13基础镜像
#
################################################

FROM ubuntu:20.04

ENV APP_HOME /srv/app
ENV TZ Asia/Shanghai
ENV LANG zh_CN.UTF-8
ENV PIP_SOURCE_URL https://pypi.tuna.tsinghua.edu.cn/simple/
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR ${APP_HOME}
COPY Python-3.7.13.tgz /tmp

#执行命令
RUN set -ex \
    && cat /dev/null > /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list \
    && echo "deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list \
    # && echo "deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse" >> /etc/apt/sources.list \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        iputils-ping \
        wget \
        net-tools \
        vim \
        curl \
        tzdata \
        build-essential \
        libsqlite3-dev libbz2-dev libncurses5-dev libgdbm-dev libnss3-dev libreadline-dev libffi-dev \
        libssl-dev zlib1g-dev libcurl4-openssl-dev \
        default-libmysqlclient-dev \
        git \
        openssh-server \
        sshpass \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

RUN set -ex \
    && cd /tmp && tar -zxvf Python-3.7.13.tgz && cd Python-3.7.13 && ./configure --enable-shared && make -j10 && make altinstall \
    && ldconfig /opt/Python3.7.13 \
    && python3.7 --version \
    && ln -s /usr/local/bin/python3.7 /usr/bin/python \
    && ln -s /usr/local/bin/pip3.7 /usr/bin/pip \
    && make clean && cd && rm -rf /tmp/Python-3.7.13* \
    && pip config set global.index-url ${PIP_SOURCE_URL} \
    && pip config set global.trusted-host ${PIP_SOURCE_URL} \
    && pip install ipython \
    && apt-get clean \
    && apt-get clean autoclean \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* $HOME/.cache /var/lib/apt/lists/* /var/lib/{apt,dpkg,cache,log}

CMD ["/bin/bash"]

# # 配置ssh
# RUN set -ex \
#     && sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
#     && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
#     && echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config \
#     && mkdir /var/run/sshd

# # 声明端口
# EXPOSE 22

# # 开始ssh服务
# CMD ["/usr/sbin/sshd", "-D"]


