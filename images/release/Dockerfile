FROM python:3.8-buster

RUN apt-get update \
  && apt-get install -y bash curl wget tar git gettext jq perl \
  && apt-get clean

RUN wget https://github.com/mikefarah/yq/releases/download/v4.17.2/yq_linux_386.tar.gz -O - |\
  tar xz && mv yq_linux_386 /usr/bin/yq

ARG GIT_CLIFF_VERSION=1.2.0
RUN wget https://github.com/orhun/git-cliff/releases/download/v${GIT_CLIFF_VERSION}/git-cliff-${GIT_CLIFF_VERSION}-x86_64-unknown-linux-gnu.tar.gz \
  && tar -zxvf git-cliff-${GIT_CLIFF_VERSION}-x86_64-unknown-linux-gnu.tar.gz \
  && mv git-cliff-${GIT_CLIFF_VERSION}/git-cliff /usr/local/bin \
  && chmod +x /usr/local/bin/git-cliff \
  && rm -rf ./git-cliff-*

ARG HELM_VERSION=3.8.0
RUN wget https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz \
  && tar -zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz \
  && mv linux-amd64/helm /usr/local/bin \
  && chmod +x /usr/local/bin/helm \
  && rm -rf linux-amd64 helm-*

ARG CR_VERSION=1.6.0
RUN wget https://github.com/helm/chart-releaser/releases/download/v${CR_VERSION}/chart-releaser_${CR_VERSION}_linux_amd64.tar.gz \
  && tar -zxvf chart-releaser_${CR_VERSION}_linux_amd64.tar.gz \
  && mv cr /usr/local/bin \
  && chmod +x /usr/local/bin/cr \
  && rm LICENSE README.md

ARG KUBECTL_VERSION=v1.21.9
ARG KUBECTL_SHASUM=195d5387f2a6ca7b8ab5c2134b4b6cc27f29372f54b771947ba7c18ee983fbe6
RUN curl -LO https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl \
  && echo "$KUBECTL_SHASUM  kubectl" | sha256sum -c \
  && chmod +x ./kubectl \
  && mv ./kubectl /usr/local/bin

# Cache repository, used frequently during chart releasing
RUN helm repo add bitnami https://charts.bitnami.com/bitnami

# Setup Committer information
RUN git config --global user.email "bot@galoy.io" \
  && git config --global user.name "CI Bot"

RUN pip install --upgrade bump2version

ENV GH_CLI_VERSION 2.23.0
RUN mkdir ghcli && cd ghcli \
  && wget https://github.com/cli/cli/releases/download/v${GH_CLI_VERSION}/gh_${GH_CLI_VERSION}_linux_386.tar.gz -O ghcli.tar.gz \
  && tar --strip-components=1 -xf ghcli.tar.gz \
  && mv bin/gh /usr/local/bin && cd ../ && rm -rf ./ghcli

RUN wget https://raw.githubusercontent.com/Ariel-Rodriguez/sh-semversion-2/main/semver2.sh \
  && chmod +x semver2.sh && mv semver2.sh /usr/local/bin/semver-compare

ENV GHTOKEN_VERSION 2.0.1
RUN wget -O ghtoken \
  https://github.com/Link-/gh-token/releases/download/v2.0.1/linux-amd64 && \
  echo "f76e8cb35f0b04b59073a486cc952e50fa9f1c930a25619ea9abcf44a13165c4  ghtoken" | \
  shasum -c - && \
  chmod u+x ./ghtoken && \
  mv ./ghtoken /usr/local/bin/ghtoken

RUN wget https://github.com/mike-engel/jwt-cli/releases/download/4.0.0/jwt-linux.tar.gz \
  && echo "6b0740c3f4c7134a0cbcf802b95b033bd2246d592ad16aa2ee2d80e5b289b4d6  jwt-linux.tar.gz" > jwt-linux.sha256 \
  && shasum --check --status ./jwt-linux.sha256 \
  && tar -xzf jwt-linux.tar.gz \
  && mv jwt /usr/local/bin/jwt

RUN wget -O- https://carvel.dev/install.sh | bash

ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin
