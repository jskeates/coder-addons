FROM codercom/code-server:4.16.1-bullseye

USER root

# apt packages
RUN apt-get update \
 && apt-get install -y curl ca-certificates uidmap build-essential \
 && apt-get upgrade -y \
 && rm -rf /var/lib/apt/lists/*

# go
RUN curl -Lo /tmp/go.tar.gz https://dl.google.com/go/go1.20.6.linux-amd64.tar.gz \
 && tar -C /usr/local -xzf /tmp/go.tar.gz \
 && rm /tmp/go.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# kubectl
RUN curl -Lo /tmp/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl \
 && chmod +x /tmp/kubectl \
 && mv /tmp/kubectl /usr/local/bin/kubectl
ENV KUBE_EDITOR=vim

# install-scripts
COPY install-scripts/ /usr/local/installable/
ENV PATH=$PATH:/usr/local/installable

USER coder
