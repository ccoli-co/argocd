ARG ARGOCD_VERSION="v2.4.0"
FROM argoproj/argocd:$ARGOCD_VERSION
ARG SOPS_VERSION="3.7.3"
ARG HELM_SECRETS_VERSION="3.14.0"
ARG KUBECTL_VERSION="1.22.0"
ENV HELM_SECRETS_HELM_PATH=/usr/local/bin/helm \
    HELM_PLUGINS="/home/argocd/.local/share/helm/plugins/" \
    HELM_SECRETS_VALUES_ALLOW_SYMLINKS=true \
    HELM_SECRETS_VALUES_ALLOW_ABSOLUTE_PATH=true \
    HELM_SECRETS_VALUES_ALLOW_PATH_TRAVERSAL=true

USER root
RUN apt-get update && \
    apt-get install -y \
      curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
RUN curl -fSSL https://github.com/mozilla/sops/releases/download/v${SOPS_VERSION}/sops-v${SOPS_VERSION}.linux \
    -o /usr/local/bin/sops && chmod +x /usr/local/bin/sops
RUN curl -fSSL https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl

USER argocd

RUN helm plugin install --version ${HELM_SECRETS_VERSION} https://github.com/jkroepke/helm-secrets
