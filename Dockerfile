FROM codercom/code-server:3.11.0

USER root

# apt packages
RUN apt-get update \
 && apt-get install -y apt-transport-https gnupg \
 && curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
 && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ buster main" > /etc/apt/sources.list.d/azure-cli.list \
 && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add - \
 && echo "deb https://deb.nodesource.com/node_14.x buster main" >> /etc/apt/sources.list.d/nodesource.list \
 && echo "deb-src https://deb.nodesource.com/node_14.x buster main" >> /etc/apt/sources.list.d/nodesource.list \
 && apt-get update \
 && apt-get install -y unzip zsh nodejs uidmap build-essential sqlite3 libsqlite3-dev vim azure-cli \
 && apt-get upgrade -y \
 && rm -rf /var/lib/apt/lists/*

# serverless
RUN npm install -g serverless

# ngrok
RUN curl -Lo /tmp/ngrok.zip https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip \
 && cd /tmp \
 && unzip /tmp/ngrok.zip \
 && mv ngrok /usr/local/bin/ngrok \
 && rm /tmp/ngrok.zip

# go
RUN curl -Lo /tmp/go.tar.gz https://dl.google.com/go/go1.16.6.linux-amd64.tar.gz \
 && tar -C /usr/local -xzf /tmp/go.tar.gz \
 && rm /tmp/go.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# docker (CLI only)
RUN curl -Lo /tmp/docker.tar.gz https://download.docker.com/linux/static/stable/x86_64/docker-20.10.2.tgz \
 && cd /tmp \
 && tar -xzf /tmp/docker.tar.gz \
 && mv /tmp/docker/docker /usr/local/bin/docker \
 && rm -rf /tmp/docker /tmp/docker.tar.gz

# docker-compose
RUN curl -Lo /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64 \
 && chmod +x /usr/local/bin/docker-compose

# kubectl
RUN curl -Lo /tmp/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.20.6/bin/linux/amd64/kubectl \
 && chmod +x /tmp/kubectl \
 && mv /tmp/kubectl /usr/local/bin/kubectl
ENV KUBE_EDITOR=vim

# kubeadm
RUN curl -Lo /tmp/kubeadm https://storage.googleapis.com/kubernetes-release/release/v1.20.6/bin/linux/amd64/kubeadm \
 && chmod +x /tmp/kubeadm \
 && mv /tmp/kubeadm /usr/local/bin/kubeadm

# helm
RUN curl -Lo /tmp/helm.tar.gz https://get.helm.sh/helm-v2.17.0-linux-amd64.tar.gz \
 && cd /tmp \
 && tar -xzf helm.tar.gz \
 && mv /tmp/linux-amd64/helm /usr/local/bin/helm2 \
 && rm -rf /tmp/linux-amd64 /tmp/helm.tar.gz

# helm3
RUN curl -Lo /tmp/helm.tar.gz https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz \
 && cd /tmp \
 && tar -xzf helm.tar.gz \
 && mv /tmp/linux-amd64/helm /usr/local/bin/helm \
 && rm -rf /tmp/linux-amd64 /tmp/helm.tar.gz

# skaffold
RUN curl -Lo /usr/local/bin/skaffold https://storage.googleapis.com/skaffold/releases/v1.25.0/skaffold-linux-amd64 \
 && chmod a+x /usr/local/bin/skaffold

# kustomize
RUN curl -Lo /tmp/kustomize.tar.gz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.1.3/kustomize_v4.1.3_linux_amd64.tar.gz \
 && cd /tmp \
 && tar -xzf kustomize.tar.gz \
 && mv /tmp/kustomize /usr/local/bin/kustomize \
 && rm -rf /tmp/kustomize.tar.gz 

# img
RUN curl -fSL "https://github.com/genuinetools/img/releases/download/v0.5.11/img-linux-amd64" -o "/usr/local/bin/img" \
 && chmod a+x "/usr/local/bin/img"

# ctr (containerd CLI)
RUN curl -Lo /tmp/ctr.tar.gz https://github.com/containerd/containerd/releases/download/v1.3.7/containerd-1.3.7-linux-amd64.tar.gz \
 && cd /tmp \
 && tar -xzf ctr.tar.gz \
 && mv /tmp/bin/ctr /usr/local/bin/ctr \
 && rm -rf /tmp/bin /tmp/ctr.tar.gz 

# rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --default-toolchain 1.52 -c rls -y

# fluxcd2
RUN curl -Lo /tmp/flux.tar.gz https://github.com/fluxcd/flux2/releases/download/v0.14.2/flux_0.14.2_linux_amd64.tar.gz \
 && cd /tmp \
 && tar -xzf flux.tar.gz \
 && mv /tmp/flux /usr/local/bin/flux \
 && rm -rf /tmp/flux /tmp/flux.tar.gz
 
 # k3s
RUN curl -fSL "https://github.com/k3s-io/k3s/releases/download/v1.20.6%2Bk3s1/k3s" -o "/usr/local/bin/k3s" \
 && chmod a+x "/usr/local/bin/k3s"

# aws v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.2.22.zip" -o "/tmp/awscliv2.zip" \
 && cd /tmp \
 && unzip awscliv2.zip \
 && ./aws/install \
 && rm -rf /tmp/aws /tmp/awscliv2.zip

USER coder
