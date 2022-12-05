FROM codercom/code-server:4.8.3-focal

USER root

# apt packages
RUN apt-get update \
 && apt-get install -y apt-transport-https gnupg \
 && curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null \
 && echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ buster main" > /etc/apt/sources.list.d/azure-cli.list \
 && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add - \
 && echo "deb https://deb.nodesource.com/node_18.x buster main" >> /etc/apt/sources.list.d/nodesource.list \
 && echo "deb-src https://deb.nodesource.com/node_18.x buster main" >> /etc/apt/sources.list.d/nodesource.list \
 && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" >> /etc/apt/sources.list.d/google-cloud-sdk.list \
 && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
 && apt-get update \
 && apt-get install -y unzip zsh nodejs uidmap build-essential sqlite3 libsqlite3-dev vim azure-cli google-cloud-cli \
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
RUN curl -Lo /tmp/go.tar.gz https://dl.google.com/go/go1.19.1.linux-amd64.tar.gz \
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
RUN curl -Lo /tmp/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubectl \
 && chmod +x /tmp/kubectl \
 && mv /tmp/kubectl /usr/local/bin/kubectl
ENV KUBE_EDITOR=vim

# kubeadm
RUN curl -Lo /tmp/kubeadm https://storage.googleapis.com/kubernetes-release/release/v1.23.6/bin/linux/amd64/kubeadm \
 && chmod +x /tmp/kubeadm \
 && mv /tmp/kubeadm /usr/local/bin/kubeadm

# helm2
RUN curl -Lo /tmp/helm.tar.gz https://get.helm.sh/helm-v2.17.0-linux-amd64.tar.gz \
 && cd /tmp \
 && tar -xzf helm.tar.gz \
 && mv /tmp/linux-amd64/helm /usr/local/bin/helm2 \
 && rm -rf /tmp/linux-amd64 /tmp/helm.tar.gz

# helm
RUN curl -Lo /tmp/helm.tar.gz https://get.helm.sh/helm-v3.8.2-linux-amd64.tar.gz \
 && cd /tmp \
 && tar -xzf helm.tar.gz \
 && mv /tmp/linux-amd64/helm /usr/local/bin/helm \
 && rm -rf /tmp/linux-amd64 /tmp/helm.tar.gz

# skaffold
RUN curl -Lo /usr/local/bin/skaffold https://storage.googleapis.com/skaffold/releases/v1.39.1/skaffold-linux-amd64 \
 && chmod a+x /usr/local/bin/skaffold

# kustomize
RUN curl -Lo /tmp/kustomize.tar.gz https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.5.4/kustomize_v4.5.4_linux_amd64.tar.gz \
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

# fluxcd2 0.14.2
RUN curl -Lo /tmp/flux.tar.gz https://github.com/fluxcd/flux2/releases/download/v0.14.2/flux_0.14.2_linux_amd64.tar.gz \
 && cd /tmp \
 && tar -xzf flux.tar.gz \
 && mv /tmp/flux /usr/local/bin/flux14 \
 && rm -rf /tmp/flux /tmp/flux.tar.gz

# fluxcd2 0.29.5
RUN curl -Lo /tmp/flux.tar.gz https://github.com/fluxcd/flux2/releases/download/v0.29.5/flux_0.29.5_linux_amd64.tar.gz \
 && cd /tmp \
 && tar -xzf flux.tar.gz \
 && mv /tmp/flux /usr/local/bin/flux \
 && rm -rf /tmp/flux /tmp/flux.tar.gz
 
 # k3s
RUN curl -fSL "https://github.com/k3s-io/k3s/releases/download/v1.23.6%2Bk3s1/k3s" -o "/usr/local/bin/k3s" \
 && chmod a+x "/usr/local/bin/k3s"

# aws v2
# release list: https://github.com/aws/aws-cli/tags
RUN curl -L "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.7.29.zip" -o "/tmp/awscliv2.zip" \
 && cd /tmp \
 && unzip awscliv2.zip \
 && ./aws/install \
 && rm -rf /tmp/aws /tmp/awscliv2.zip

# terraform
# release list: https://github.com/hashicorp/terraform/releases
RUN curl -L "https://releases.hashicorp.com/terraform/1.2.5/terraform_1.2.5_linux_amd64.zip" -o "/tmp/terraform.zip" \
 && cd /tmp \
 && unzip terraform.zip \
 && mv /tmp/terraform /usr/local/bin/terraform \
 && rm -rf /tmp/terraform.zip

# nats - NATS CLI
# release list: https://github.com/nats-io/natscli/releases
RUN curl -L "https://github.com/nats-io/natscli/releases/download/v0.0.33/nats-0.0.33-linux-amd64.zip" -o "/tmp/nats.zip" \
 && cd /tmp \
 && unzip nats.zip \
 && mv /tmp/nats-0.0.33-linux-amd64/nats /usr/local/bin/nats \
 && rm -rf /tmp/nats-0.0.33-linux-amd64 /tmp/nats.zip

USER coder
