FROM ubuntu:22.04 AS base
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y software-properties-common sudo vim && \
    apt-get install -y python3 python3-pip && \
    pip3 install ansible && \
    rm -rf /var/lib/apt/lists/*

FROM base AS duc
RUN addgroup --gid 1000 duc && \
    adduser --disabled-password --gecos duc --uid 1000 --gid 1000 duc && \
    echo "duc ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER duc
WORKDIR /home/duc

FROM duc
COPY . .
CMD ["sh", "-c", "ansible-playbook -i hosts $OPTS local.yml; bash"]
