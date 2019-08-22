FROM ubuntu:18.04 as build

RUN apt update && \
    apt install -y curl unzip && \
    curl -o /tmp/consul-template.zip https://releases.hashicorp.com/consul-template/0.20.0/consul-template_0.20.0_linux_amd64.zip && \
    unzip -d /usr/bin/ /tmp/consul-template.zip

FROM ubuntu:18.04

COPY --from=build /usr/bin/consul-template /usr/bin/consul-template
RUN mkdir /etc/consul-template/

RUN apt update &&\
    apt install -y nginx supervisor

RUN unlink /etc/nginx/sites-enabled/default
# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

COPY supervisor_consul-template.conf /etc/supervisor/conf.d/consul-template.conf
COPY consul-template.hcl /etc/consul-template/config.hcl
COPY nginx-balancer.ctmpl /etc/consul-template/

EXPOSE 80
WORKDIR /app
COPY entrypoint.sh .
ENTRYPOINT ["/app/entrypoint.sh"]
