port: 4466
#managementApiSecret: ${API_SECRET}
databases:
  default:
    connector: mysql
    host: ${DB_HOST}
    port: ${DB_PORT}
    user: ${DB_USER}
    password: ${DB_PASS}
    migrations: true