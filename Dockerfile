FROM codercom/code-server:3.7.2

USER root

# apt packages
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash - \ 
 && apt-get update \
 && apt-get install -y unzip zsh nodejs \
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
RUN curl -Lo /tmp/go.tar.gz https://dl.google.com/go/go1.15.5.linux-amd64.tar.gz \
 && tar -C /usr/local -xzf /tmp/go.tar.gz \
 && rm /tmp/go.tar.gz
ENV PATH=$PATH:/usr/local/go/bin

# docker (CLI only)
RUN curl -Lo /tmp/docker.tar.gz https://download.docker.com/linux/static/stable/x86_64/docker-19.03.1.tgz \
 && cd /tmp \
 && tar -xzf /tmp/docker.tar.gz \
 && mv /tmp/docker/docker /usr/local/bin/docker \
 && rm -rf /tmp/docker /tmp/docker.tar.gz

# docker-compose
RUN curl -Lo /usr/local/bin/docker-compose https://github.com/docker/compose/releases/download/1.27.4/docker-compose-Linux-x86_64

# kubectl
RUN curl -Lo /tmp/kubectl https://storage.googleapis.com/kubernetes-release/release/v1.19.4/bin/linux/amd64/kubectl \
 && chmod +x /tmp/kubectl \
 && mv /tmp/kubectl /usr/local/bin/kubectl

# kubeadm
RUN curl -Lo /tmp/kubeadm https://storage.googleapis.com/kubernetes-release/release/v1.19.4/bin/linux/amd64/kubeadm \
 && chmod +x /tmp/kubeadm \
 && mv /tmp/kubeadm /usr/local/bin/kubeadm

# helm
RUN curl -Lo /tmp/helm.tar.gz https://get.helm.sh/helm-v2.17.0-linux-amd64.tar.gz \
 && cd /tmp \
 && tar -xzf helm.tar.gz \
 && mv /tmp/linux-amd64/helm /usr/local/bin/helm \
 && rm -rf /tmp/linux-amd64 /tmp/helm.tar.gz

# helm3
RUN curl -Lo /tmp/helm.tar.gz https://get.helm.sh/helm-v3.4.1-linux-amd64.tar.gz \
 && cd /tmp \
 && tar -xzf helm.tar.gz \
 && mv /tmp/linux-amd64/helm /usr/local/bin/helm3 \
 && rm -rf /tmp/linux-amd64 /tmp/helm.tar.gz


USER coder
