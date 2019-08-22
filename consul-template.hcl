consul {
    address = "%CONSUL_ADDR%"
    retry {
        enabled = true
        attempts = 12
        backoff = "250ms"
    }
}

template {
    source = "/etc/consul-template/nginx-balancer.ctmpl"
    dest = "/etc/nginx/conf.d/server.conf"
    command = "nginx -s reload"
}
