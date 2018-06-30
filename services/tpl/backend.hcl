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
        network_mode = "host"
        force_pull = true
      }
      resources {
        cpu = 3000
        memory = 2000
        network {
          mbits = 10
          port "backend" {
            static = 4000
          }
        }
      }
      env {
        PRISMA_ENDPOINT = "http://prisma.service.consul:4466"
        APP_SECRET = "${APP_SECRET}"
        LDAP_URL = "${LDAP_URL}"
        LDAP_PRINCIPAL = "${LDAP_PRINCIPAL}"
        LDAP_PASSWORD = "${LDAP_PASSWORD}"
        LDAP_SEARCH_BASE = "${LDAP_SEARCH_BASE}"
        LDAP_SEARCH_FILTER = "${LDAP_SEARCH_FILTER}"
      }
      service {
        name = "app"
        port = "backend"

        tags = [
          "backend",
          "urlprefix-backend${ENV}.mimacom-tm.tk/"
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