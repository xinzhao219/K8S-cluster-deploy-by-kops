FROM alpine:3.9 AS builder

ENV HELMVERSION v3.3.4
ENV KUBECTLVERSION v1.18.0
# ENV YQVERSION 2.4.0

RUN apk add --no-cache curl bind-tools

COPY cluster.conf /cluster.conf


# Download Helm
ENV FILENAME helm-${HELMVERSION}-linux-amd64.tar.gz
ENV HELM_URL https://get.helm.sh/${FILENAME}
RUN curl -Lsfo /tmp/$FILENAME ${HELM_URL} \
  && tar -zxvf /tmp/${FILENAME} -C /tmp \
  && mv /tmp/linux-amd64/helm /helm \
  && rm -rf /tmp

# Download kubectl
# Note: Latest version may be found on:
# https://aur.archlinux.org/packages/kubectl-bin/
RUN curl -Lsfo kubectl https://storage.googleapis.com/kubernetes-release/release/${KUBECTLVERSION}/bin/linux/amd64/kubectl

################################################################################
FROM alpine:3.9

# Install required packages
# This lot required for aws-cli and helm plugins
# RUN apk add --update git bash curl python py-pip openssl ca-certificates
RUN apk add --update python py-pip ca-certificates

# Install AWSCLI
RUN pip install --upgrade pip awscli

# Install kubectl
COPY --from=builder /kubectl /usr/local/bin/kubectl

ENV HOME=/home/kubectl
RUN set -x && \
  chmod +x /usr/local/bin/kubectl && \
  # Create non-root user.
  adduser kubectl -Du 1000 -h $HOME && \
  # Basic check it works.
  kubectl version --client

# Install Helm
COPY --from=builder /helm /usr/local/bin/helm

# Setup Kubernetes Environment
COPY --from=builder /config.yaml $HOME/.kube/config
RUN chown -R kubectl: $HOME

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER kubectl

ENTRYPOINT ["/entrypoint.sh"]
