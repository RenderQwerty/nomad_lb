job "lb" {
  region = "emea"
  datacenters = ["incountry"]

  constraint {
    distinct_hosts = true
  }

  update {
    max_parallel = 1
    min_healthy_time = "10s"
    healthy_deadline = "3m"
    progress_deadline = "10m"
    auto_revert = false
    canary = 0
  }

  migrate {
    max_parallel = 1
    health_check = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
  }

  group "load_balancers" {
    count = 1
    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "consul-template" {
      constraint {
        attribute = "${meta.type}"
        value = "aws"
      }
      env {
        CONSUL_ADDR = "${attr.unique.network.ip-address}:8500"
        CONSUL_TOKEN = "<< INSERT VALID TOKEN HERE >>"
      }

      driver = "docker"
      config {
        image = "jaels/consul-template"
        port_map {
          http = 80
        }
      }

      resources {
        cpu    = 1000
        memory = 300
        network {
          mbits = 10
          port "http" {
            static = 80
          }
        }
      }

      service {
        name = "loadbalancer"
        tags = ["lb"]
        port = "http"
        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
  }
}
