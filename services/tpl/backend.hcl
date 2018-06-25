job "backend" {
  datacenters = [
    "eu-central-1a",
    "eu-central-1b",
    "eu-central-1c"
  ]

  group "backend" {
    task "backend" {
      driver = "docker"
      config {
        image = "ntrp/tm-backend:latest"
        port_map {
          backend = 4000
        }
      }
      resources {
        cpu = 3000
        memory = 2000
        network {
          mbits = 10
          port "backend" {}
        }
      }
      env {
        PRISMA_ENDPOINT = "http://$${NOMAD_ADDR_prisma_prisma}"
        APP_SECRET = "${APP_SECRET}"
      }
      service {
        name = "app"
        port = "backend"

        tags = [
          "backend",
          "urlprefix-${ELB_ADDR}/"
        ]

        check {
          type = "tcp"
          port = "backend"
          interval = "10s"
          timeout = "2s"
        }
      }
    }
  }
}