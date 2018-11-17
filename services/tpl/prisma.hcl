job "prisma" {
  datacenters = [
    "dc1",
    "eu-central-1a",
    "eu-central-1b",
    "eu-central-1c"
  ]

  group "prisma" {
    task "prisma" {
      driver = "docker"
      config {
        image = "prismagraphql/prisma:1.10.0"
        port_map {
          prisma = 4466
        }
      }
      resources {
        cpu = 512
        memory = 400
        network {
          mbits = 10
          port "prisma" {
            static = 4466
          }
        }
      }
      env {
        PRISMA_CONFIG = <<CONFIG
${PRISMA_CONFIG}
CONFIG
      }
      service {
        name = "prisma"
        port = "prisma"

        tags = [
          "prisma"
        ]

        check {
          type = "tcp"
          port = "prisma"
          interval = "10s"
          timeout = "2s"
        }
      }
    }
  }
}