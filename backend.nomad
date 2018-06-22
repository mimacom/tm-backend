job "backend" {
  datacenters = [
    "eu-central-1a"
  ]

  group "prisma" {
    task "prisma" {
      driver = "docker"
      config {
        image = "prismagraphql/prisma:latest"
        port_map {
          prisma = 4466
        }
      }
      resources {
        cpu = 2400
        memory = 512
        network {
          mbits = 10
          port "prisma" {}
        }
      }
      env {
        PORT = 4466
        SQL_CLIENT_HOST_CLIENT1 = "${DB_HOST}"
        SQL_CLIENT_HOST_READONLY_CLIENT1 = "${DB_HOST}"
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
        CLUSTER_ADDRESS = "http://$${attr.unique.hostname}:4466"
        SQL_INTERNAL_CONNECTION_LIMIT = 10
        SCHEMA_MANAGER_SECRET = "graphcool"
        SCHEMA_MANAGER_ENDPOINT = "http://$${attr.unique.hostname}:4466/cluster/schema"
        CLUSTER_PUBLIC_KEY = ""
        BUGSNAG_API_KEY = ""
        ENABLE_METRICS = 0
        JAVA_OPTS = ""
      }
    }
  }
}