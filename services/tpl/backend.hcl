job "backend" {
  datacenters = [
    "dc1",
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
        cpu = 512
        memory = 256
        network {
          mbits = 10
          port "backend" {
            static = 4000
          }
          port "debug" {
            static = 9229
          }
        }
      }
      env {
        PRISMA_ENDPOINT = "http://$${NOMAD_IP_backend}:4466"
        PRISMA_DEBUG = "true"
        JWT_SECRET = "${JWT_SECRET}"
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
          "urlprefix-backend-${ENV}.tm.mimacom.solutions/"
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