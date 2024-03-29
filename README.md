# odoo-test
![odoo](https://img.shields.io/badge/odoo-_16-844FBA)

A Bitnami Odoo Container for runnning Odoo Tests

## Usage
1. Create a network
```sh
docker network create odoo-network
```
2. Create a PostgreSQL container from Bitnami
```sh
docker run -d --name postgresql \
  --env POSTGRESQL_USERNAME=bn_odoo \
  --env POSTGRESQL_PASSWORD=bitnami \
  --env POSTGRESQL_DATABASE=bitnami_odoo \
  --network odoo-network \
  bitnami/postgresql:latest
```
3. Create a PostgreSQL container from Bitnami
```sh
docker run -t --name odoo-test \
  --env ODOO_TEST_TAGS=YOUR_ODOO_TEST_TAGS \
  --env ODOO_DATABASE_ADMIN_PASSWORD=bitnami \
  --env ODOO_DATABASE_NAME=bitnami_odoo \
  --env ODOO_DATABASE_USER=bn_odoo \
  --env ODOO_DATABASE_PASSWORD=bitnami \
  --env ODOO_DATABASE_HOST=postgresql \
  --env ODOO_DATABASE_PORT_NUMBER=5432 \
  --network odoo-network \
  --volume path/to/odoo/addons:/bitnami/odoo/addons \
  ghcr.io/craftschoolship/odoo-test:16
```

> **TODO** replace `YOUR_ODOO_TEST_TAGS` with the test tags you want to run

> **TODO** replace `path/to/odoo/addons` with the path to the folder containing the module(s) to test