FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ARG user=wj
ARG uid=1000
ARG gid=1000

RUN sed -i "s/archive.ubuntu.com/mirrors.tuna.tsinghua.edu.cn/g" /etc/apt/sources.list \
  ; apt update \
 && apt install -y \
        vim \
        git \
        locales \
        bash \
        bash-completion \
        cmake \
  ; locale-gen en_US.UTF-8 \
  ; echo "## Add by WJ" >> /root/.bashrc \
  ; echo "export LANG=en_US.utf-8" >> /root/.bashrc \
  ; echo "export LC_ALL=en_US.utf-8" >> /root/.bashrc \
  ; echo ". /usr/share/bash-completion/bash_completion" >> /root/.bashrc \
  ; echo "export PS1=\"[\\u~\\A \\[\\e[32m\\]\\w\\[\\e[m\\]] \\[\\e[36m\\]\\$\\[\\e[m\\] \"" >> /root/.bashrc \
  ; echo "set completion-ignore-case on" >> /root/.inputrc \
  ; echo "\"\\e[A\": history-search-backward" >> /root/.inputrc \
  ; echo "\"\\e[B\": history-search-forward" >> /root/.inputrc \
  ; echo "\"\\e[1;5C\": forward-word" >> /root/.inputrc \
  ; echo "\"\\e[1;5D\": backward-word" >> /root/.inputrc \
  ; echo "\"\\e[5C\": forward-word" >> /root/.inputrc \
  ; echo "\"\\e[5D\": backward-word" >> /root/.inputrc \
  ; echo "\"\\e\\e[1;5C\": forward-word" >> /root/.inputrc \
  ; echo "\"\\e\\e[1;5D\": backward-word" >> /root/.inputrc \
  ; echo "## Add Done." >> /root/.bashrc

# python
RUN apt install -y \
        python3 \
        python3-pip \
  ; apt install -y \
        tcl-dev \
        tk-dev \
        python3-tk \
  ; python3 -m pip install -U pip \
  ; python3 -m pip config set global.index-url https://pypi.douban.com/simple \
  ; python3 -m pip config set global.trusted-host https://pypi.douban.com \
  ; python3 -m pip install \
        numpy \
        matplotlib \
        opencv-python \
        ipython

# User
RUN apt install -y sudo \
  ; echo "%sudo ALL=(ALL:ALL) NOPASSWD:ALL" >> /etc/sudoers \
  ; groupadd -g ${gid} %{user} \
  ; useradd --create-home --no-log-init -u ${uid} -g ${gid} --shell /bin/bash ${user} \
  ; usermod -aG sudo ${user} \
  ; echo "${user}:1" | chpasswd \
  ; cp /root/.inputrc /home/${user}/

# gcc
# COPY ./tools/gcc-ubuntu-9.3.0-2020.03-x86_64-aarch64-linux-gnu.tar.gz /tmp/
# RUN cd /tmp \
#   ; tar xzf gcc-ubuntu-9.3.0-2020.03-x86_64-aarch64-linux-gnu.tar.gz -C /opt/ \
#   ; rm ./gcc-ubuntu-9.3.0-2020.03-x86_64-aarch64-linux-gnu.tar.gz

WORKDIR /workspace
ENTRYPOINT ["/bin/bash" "-c"]
