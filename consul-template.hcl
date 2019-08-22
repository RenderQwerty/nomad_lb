consul {
    address = "%CONSUL_ADDR%"
    retry {
        enabled = true
        attempts = 12
        backoff = "250ms"
    }
}

template {
    source = "/etc/templates/nginx-balancer.ctmpl"
    destination = "/etc/nginx/conf.d/server.conf"
    command = "nginx -s reload"
}
