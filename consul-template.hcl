consul {
    address = "%CONSUL_ADDR%"
    retry {
        enabled = true
        attempts = 12
        backoff = "250ms"
    }
    reload_signal = "SIGHUP"
    kill_signal = "SIGINT"
    max_stale = "10m"
    log_level = "warn"
}

template {
    source = "/etc/consul-template/nginx-balancer.ctmpl"
    dest = "/etc/nginx/conf.d/server.conf"
    command = "nginx -s reload"
}
