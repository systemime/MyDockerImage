################################################
#
#  生成靶场基础镜像
#
################################################

FROM ubuntu:20.04

ENV APP_HOME /srv/app
ENV TZ Asia/Shanghai
ENV LANG zh_CN.UTF-8
ENV PIP_SOURCE_URL https://pypi.tuna.tsinghua.edu.cn/simple/
ENV DEBIAN_FRONTEND=noninteractive

WORKDIR ${APP_HOME}

#执行命令
#替换为阿里源
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
        libncurses5-dev libgdbm-dev libnss3-dev libreadline-dev libffi-dev \
        libssl-dev \
        zlib1g-dev \
        libcurl4-openssl-dev \
        default-libmysqlclient-dev \
        build-essential \
        openssh-server \
        git \
        sshpass \
    && ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone \
    # sshd配置
    && sed -ri 's/^#PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config \
    && echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config \ 
    && mkdir /var/run/sshd \
    && apt install software-properties-common -y \
    && add-apt-repository ppa:deadsnakes/ppa -y \
    && apt-get update 

COPY get-pip.py /tmp
RUN set -ex \
    && apt install python3.7 -y \
    && apt install python3.7-dev python3.7-venv python3.7-distutils python3.7-gdbm python3.7-tk -y \
    && ln -s /usr/bin/python3.7 /usr/bin/python \
    && python3.7 /tmp/get-pip.py \
    && pip config set global.index-url ${PIP_SOURCE_URL} \
    && pip install ipython \
    && apt-get clean \
    && apt-get clean autoclean \
    && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* $HOME/.cache /var/lib/apt/lists/* /var/lib/{apt,dpkg,cache,log}



# COPY Python-3.7.13.tgz /tmp
# RUN set -ex \
#     && cd /tmp && tar -zxvf Python-3.7.13.tgz && cd Python-3.7.13 && ./configure prefix=/usr/local/python3.7 && make -j16 && make install \
#     && rm -f /usr/local/bin/python \
#     && rm -f /usr/local/bin/python3 \
#     && rm -f /usr/local/bin/pip \
#     && rm -f /usr/local/bin/pip3 \
#     && rm -f /usr/bin/python \
#     && rm -f /usr/bin/python3 \
#     && rm -f /usr/bin/pip \
#     && rm -f /usr/bin/pip3 \
#     && ln -s /usr/local/python3.7/bin/python3.7 /usr/local/bin/python \
#     && ln -s /usr/local/python3.7/bin/python3.7 /usr/local/bin/python3 \
#     && ln -s /usr/local/python3.7/bin/python3.7 /usr/local/bin/python3.7 \
#     && ln -s /usr/local/python3.7/bin/python3.7 /usr/bin/python \
#     && ln -s /usr/local/python3.7/bin/python3.7 /usr/bin/python3 \
#     && ln -s /usr/local/python3.7/bin/python3.7 /usr/bin/python3.7 \
#     && ln -s /usr/local/python3.7/bin/pip3 /usr/bin/pip \
#     && ln -s /usr/local/python3.7/bin/pip3 /usr/bin/pip3 \
#     && ln -s /usr/local/python3.7/bin/pip3 /usr/local/bin/pip \
#     && ln -s /usr/local/python3.7/bin/pip3 /usr/local/bin/pip3 \
#     && make clean && rm -rf Python-3.7.13* \
#     && pip config set global.index-url ${PIP_SOURCE_URL} \
#     # && python -m pip install --upgrade pip \

# RUN set -ex \
#     && apt install software-properties-common -y \
#     && add-apt-repository ppa:deadsnakes/ppa -y \
#     && apt-get update

# RUN set -ex \
#     && apt install python3.7 -y \
#     && ln -s /usr/bin/python3.7 /usr/bin/python && ln -s /usr/bin/python3.7 /usr/bin/python3 \
#     && apt install python3-pip -y \
#     && pip install -U pip setuptools wheel \
#     && apt install python3.7-dev python3.7-venv python3.7-distutils python3.7-gdbm python3.7-tk -y





#     && whereis python && which python \
#     && pip install ipython \
#     && apt-get clean \
#     && apt-get clean autoclean \
#     && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* $HOME/.cache /var/lib/apt/lists/* /var/lib/{apt,dpkg,cache,log}


# 声明端口
EXPOSE 22

#开始ssh服务
CMD ["/usr/sbin/sshd", "-D"]
