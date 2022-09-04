FROM alpine:3.15.0

RUN apk add --no-cache git git-crypt curl bash

RUN QBEC_VER=0.15.1 \
 && wget -O- https://github.com/splunk/qbec/releases/download/v${QBEC_VER}/qbec-linux-amd64.tar.gz \
     | tar -C /tmp -xzf - \
 && mv /tmp/qbec /tmp/jsonnet-qbec /usr/local/bin/

RUN KUBECTL_VER=1.23.4 \
 && wget -O /usr/local/bin/kubectl \
      https://dl.k8s.io/release/v${KUBECTL_VER}/bin/linux/amd64/kubectl \
 && chmod +x /usr/local/bin/kubectl

RUN HELM_VER=3.0.2 \
 && wget -O- https://get.helm.sh/helm-v${HELM_VER}-linux-amd64.tar.gz \
     | tar -C /tmp -zxf - \
 && mv /tmp/linux-amd64/helm /usr/local/bin/helm

RUN curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | \
    bash -s -- -i /opt/yandex-cloud -n
	
ENV PATH="/opt/yandex-cloud/bin:${PATH}"

RUN yc config profile create sa-profile
