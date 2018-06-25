job "prisma" {
  datacenters = [
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
        cpu = 3000
        memory = 2000
        network {
          mbits = 10
          port "prisma" {}
        }
      }
      env {
        PORT = 4466
        SQL_CLIENT_HOST = "${DB_HOST}"
        SQL_CLIENT_PORT = 3306
        SQL_CLIENT_USER = "prisma"
        SQL_CLIENT_PASSWORD = "${DB_PASS}"
        SQL_CLIENT_CONNECTION_LIMIT = 10
        SQL_INTERNAL_HOST = "${DB_HOST}"
        SQL_INTERNAL_PORT = 3306
        SQL_INTERNAL_USER = "prisma"
        SQL_INTERNAL_PASSWORD = "${DB_PASS}"
        SQL_INTERNAL_DATABASE = "graphcool"
        SQL_INTERNAL_CONNECTION_LIMIT = 10
        CLUSTER_ADDRESS = "http://$${NOMAD_ADDR_prisma_prisma}"
        SCHEMA_MANAGER_SECRET = "graphcool"
        BUGSNAG_API_KEY = ""
        MANAGEMENT_API_SECRET = ""
        PRISMA_MANAGEMENT_API_JWT_SECRET = ""
        JAVA_OPTS = "-Xmx1G"
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