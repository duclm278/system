FROM ubuntu:24.04 AS base
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common sudo vim && \
    apt-get install -y python3 python3-pip pipx && \
    apt-get install -y ansible && \
    pipx ensurepath && \
    rm -rf /var/lib/apt/lists/*

FROM base AS sudo
RUN echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER ubuntu
WORKDIR /home/ubuntu/system

FROM sudo
COPY . .
CMD ["bash", "-c", "ansible-playbook -i hosts $OPTS local.yml; bash"]
