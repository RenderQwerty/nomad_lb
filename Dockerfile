FROM ubuntu:18.04 as build
ARG CONSUL_TEMPLATE-URL="https://releases.hashicorp.com/consul-template/0.20.0/consul-template_0.20.0_linux_amd64.zip"

RUN apt update && \
    apt install -y curl unzip && \
    curl -o /tmp/consul-template.zip "${CONSUL_TEMPLATE-URL}" \
    unzip -d /usr/bin/ /tmp/consul-template.zip

FROM ubuntu:18.04

COPY --from=build /usr/bin/consul-template /usr/bin/consul-template

RUN apt update &&\
    apt install -y nginx supervisor && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

RUN unlink /etc/nginx/sites-enabled/default


# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir /etc/consul-template/
COPY consul-template.hcl /etc/consul-template/config.hcl

EXPOSE 80
ENTRYPOINT ["entrypoint.sh"]
