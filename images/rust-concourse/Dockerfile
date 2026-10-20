FROM rust

RUN rustc --version

RUN rustup component add rustfmt
RUN rustup component add clippy

ENV CARGO_NEXTEST_VERSION 0.9.148
ENV CARGO_DENY_VERSION 0.19.0
ENV CARGO_AUDIT_VERSION 0.22.2
ENV TYPOS_CLI_VERSION 1.51.1
ENV SQLX_CLI_VERSION 0.8.6
ENV HANDLEBARS_CLI_VERSION 1.0.0

RUN cargo install --locked cargo-nextest --version ${CARGO_NEXTEST_VERSION}
RUN cargo install cargo-deny --version ${CARGO_DENY_VERSION} \
  && cargo install cargo-audit --version ${CARGO_AUDIT_VERSION} \
  && cargo install typos-cli --version ${TYPOS_CLI_VERSION} \
  && cargo install sqlx-cli --version ${SQLX_CLI_VERSION} \
  && cargo install handlebars-cli --version ${HANDLEBARS_CLI_VERSION}

# Install gcloud
ENV CLOUDSDK_CORE_DISABLE_PROMPTS 1
RUN curl -sSL https://sdk.cloud.google.com | bash
ENV PATH $PATH:/root/google-cloud-sdk/bin

RUN apt-get update && apt-get install -y \
  make git curl python3 jq rsync wget ca-certificates gnupg lsb-release gettext-base protobuf-compiler bc xxd

ENV YQ_VERSION 4.54.1
RUN wget https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64.tar.gz -O - |\
  tar xz && mv yq_linux_amd64 /usr/bin/yq

RUN apt-get remove -y docker docker.io runc
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
RUN echo  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
  && apt-get update \
  && apt-get install -y docker-ce docker-ce-cli containerd.io

ENV DOCKER_COMPOSE_VERSION 2.40.3
RUN mkdir -p /usr/local/lib/docker/cli-plugins \
  && curl -SL https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose \
  && chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

ENV GH_CLI_VERSION 2.102.0
RUN mkdir ghcli && cd ghcli \
  && wget https://github.com/cli/cli/releases/download/v${GH_CLI_VERSION}/gh_${GH_CLI_VERSION}_linux_amd64.tar.gz -O ghcli.tar.gz \
  && tar --strip-components=1 -xf ghcli.tar.gz \
  && mv bin/gh /usr/local/bin && cd ../ && rm -rf ./ghcli

ENV BUF_VERSION 1.74.0
RUN wget https://github.com/bufbuild/buf/releases/download/v${BUF_VERSION}/buf-Linux-x86_64 -O buf \
  && chmod +x buf && mv buf /usr/local/bin

RUN git clone https://github.com/bats-core/bats-core.git \
  && cd bats-core \
  && ./install.sh /usr/local

ENV GHTOKEN_VERSION 2.0.10
RUN wget -O ghtoken \
  https://github.com/Link-/gh-token/releases/download/v${GHTOKEN_VERSION}/linux-amd64 && \
  echo "342adb88bb2c5d334a0f6d5fc094e3de4e755c6ccef45a2fd55ed6b1d79cd8a6  ghtoken" | \
  shasum -c - && \
  chmod u+x ./ghtoken && \
  mv ./ghtoken /usr/local/bin/ghtoken
