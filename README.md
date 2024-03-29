# odoo-test
![odoo](https://img.shields.io/badge/odoo-_16-844FBA)

A Bitnami Odoo Container for running Odoo Tests

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
3. Init odoo data with a dry-run
```sh
docker run -t --name odoo-test-init \
  --env ODOO_TEST_TAGS=YOUR_ODOO_TEST_TAGS \
  --env ODOO_DATABASE_ADMIN_PASSWORD=bitnami \
  --env ODOO_DATABASE_NAME=bitnami_odoo \
  --env ODOO_DATABASE_USER=bn_odoo \
  --env ODOO_DATABASE_PASSWORD=bitnami \
  --env ODOO_DATABASE_HOST=postgresql \
  --env ODOO_DATABASE_PORT_NUMBER=5432 \
  --network odoo-network \
  --volume /path/to/odoo/volume:/bitnami/odoo \
  ghcr.io/craftschoolship/odoo-test:16-sat
```

> **TODO** replace `YOUR_ODOO_TEST_TAGS` with the test tags you want to run

> **TODO** replace `/path/to/odoo/volume` with the path to an **EMPTY** folder where you want to setup your odoo instance

4. Copy your module(s) to the new addons folder
```sh
cp -r ./my_module /path/to/odoo/volume/addons/my_module
```

5. Create an Odoo Test container to actually run your tests
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
  --volume /path/to/odoo/volume/addons:/bitnami/odoo/addons \
  ghcr.io/craftschoolship/odoo-test:16-sat
```

> **TODO** replace `YOUR_ODOO_TEST_TAGS` with the test tags you want to run

> **TODO** replace `path/to/odoo/volume/addons` with the path to the folder containing the module(s) to test under the 