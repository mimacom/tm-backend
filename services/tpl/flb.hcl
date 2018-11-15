job "flb" {
  datacenters = [
    "dc1",
    "eu-central-1a",
    "eu-central-1b",
    "eu-central-1c"
  ]

  type = "system"

  update {
    stagger = "5s"
    max_parallel = 1
  }

  group "flb" {
    task "flb" {
      driver = "exec"

      config {
        command = "fabio-1.5.9-go1.10.2-linux_amd64"
      }

      artifact {
        source = "https://github.com/fabiolb/fabio/releases/download/v1.5.9/fabio-1.5.9-go1.10.2-linux_amd64"
      }

      resources {
        cpu = 500
        memory = 128
        network {
          mbits = 1

          port "http" {
            static = 9999
          }
          port "ui" {
            static = 9998
          }
        }
      }
    }
  }
}