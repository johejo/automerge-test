FROM debian:stable-slim
RUN apt update && apt install -y --no-install-suggests --no-install-recommends git wget jq
WORKDIR /opt/hub
ENV HUB_VERSION=2.12.8
RUN wget -q -O - https://github.com/github/hub/releases/download/v${HUB_VERSION}/hub-linux-amd64-${HUB_VERSION}.tgz \
    | tar zx -C /opt/hub --strip-components 1 && \
    /opt/hub/install && \
    hub --version
COPY ./entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
