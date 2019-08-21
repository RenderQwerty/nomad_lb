#!/usr/bin/env bash

if [ -z "${CONSUL_ADDR}" ]; then
  echo 'You should define ${CONSUL_ADDR} environment variable'
  exit 1
fi

if [ -z "${CONSUL_TOKEN}" ]; then
  echo 'You should define ${CONSUL_TOKEN} environment variable'
  exit 1
fi

sed -i -e "s/%CONSUL_ADDR%/${CONSUL_ADDR}/" /etc/consul-template/config.hcl

exec supervisord --nodaemon -c /etc/supervisor/supervisord.conf
