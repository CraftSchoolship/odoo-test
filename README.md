# odoo-test
![odoo](https://img.shields.io/badge/odoo-_16-844FBA)

A Bitnami Odoo Container for running Odoo Tests

## Usage
1. Create a network
```sh
docker network create odoo-test-network
```
2. Create a PostgreSQL container from Bitnami
```sh
docker run -d --name odoo-test-postgresql \
  --env POSTGRESQL_USERNAME=bn_odoo \
  --env POSTGRESQL_PASSWORD=bitnami \
  --env POSTGRESQL_DATABASE=bitnami_odoo \
  --network odoo-test-network \
  bitnami/postgresql:16.2.0
```
3. Init odoo data with a dry-run
```sh
docker run -t --name odoo-test \
  --env ODOO_TEST_TAGS=/empty_module \
  --env ODOO_DATABASE_ADMIN_PASSWORD=bitnami \
  --env ODOO_DATABASE_NAME=bitnami_odoo \
  --env ODOO_DATABASE_USER=bn_odoo \
  --env ODOO_DATABASE_PASSWORD=bitnami \
  --env ODOO_DATABASE_HOST=odoo-test-postgresql \
  --env ODOO_DATABASE_PORT_NUMBER=5432 \
  --network odoo-test-network \
  --volume /path/to/odoo/volume:/bitnami/odoo \
  ghcr.io/craftschoolship/odoo-test:16.0.1-sat
```

> **TODO** replace `YOUR_ODOO_TEST_TAGS` with the test tags you want to run

> **TODO** replace `/path/to/odoo/volume` with the path to an **EMPTY** folder where you want to setup your odoo instance

4. Delete the init container
```sh
docker rm odoo-test
```

5. Enable write to protected addons folder
```sh
<sudo> chmod -R ugao+w /path/to/odoo/volume/addons
```

6. Copy your module(s) to the new addons folder
```sh
cp -r ./my_module /path/to/odoo/volume/addons/my_module
```

7. Create an Odoo Test container to actually run your tests
```sh
docker run -t --name odoo-test \
  --env MODULES_TO_INSTALL=MODULES_YOU_WANT_TO_INSTALL \
  --env ODOO_TEST_TAGS=YOUR_ODOO_TEST_TAGS \
  --env ODOO_DATABASE_ADMIN_PASSWORD=bitnami \
  --env ODOO_DATABASE_NAME=bitnami_odoo \
  --env ODOO_DATABASE_USER=bn_odoo \
  --env ODOO_DATABASE_PASSWORD=bitnami \
  --env ODOO_DATABASE_HOST=odoo-test-postgresql \
  --env ODOO_DATABASE_PORT_NUMBER=5432 \
  --network odoo-test-network \
  --volume /path/to/odoo/volume:/bitnami/odoo \
  ghcr.io/craftschoolship/odoo-test:16.0.1-sat
```

> **TODO** replace `MODULES_YOU_WANT_TO_INSTALL` with the name of your module *(or multiple modules comma separated)*

> **TODO** replace `YOUR_ODOO_TEST_TAGS` with the test tags you want to run *(use `/my_module` to test a module)*

> **TODO** replace `path/to/odoo/volume/addons` with the path to the folder where you setup your odoo instance

### Bash Script
```sh
docker network create odoo-test-network
docker run -d --name odoo-test-postgresql --env POSTGRESQL_USERNAME=bn_odoo --env POSTGRESQL_PASSWORD=bitnami --env POSTGRESQL_DATABASE=bitnami_odoo --network odoo-test-network bitnami/postgresql:16.2.0
docker run -t --name odoo-test --env ODOO_TEST_TAGS=/empty_module --env ODOO_DATABASE_ADMIN_PASSWORD=bitnami --env ODOO_DATABASE_NAME=bitnami_odoo --env ODOO_DATABASE_USER=bn_odoo --env ODOO_DATABASE_PASSWORD=bitnami --env ODOO_DATABASE_HOST=odoo-test-postgresql --env ODOO_DATABASE_PORT_NUMBER=5432 --network odoo-test-network --volume $ODOO_VOLUME:/bitnami/odoo ghcr.io/craftschoolship/odoo-test:16.0.1-sat
docker rm odoo-test
chmod -R ugao+w $ODOO_VOLUME/addons
cp -r ./$ODOO_MODULE_NAME $ODOO_VOLUME/addons/$ODOO_MODULE_NAME
docker run -t --name odoo-test --env MODULES_TO_INSTALL=$ODOO_MODULE_NAME --env ODOO_TEST_TAGS=/$ODOO_MODULE_NAME --env ODOO_DATABASE_ADMIN_PASSWORD=bitnami --env ODOO_DATABASE_NAME=bitnami_odoo --env ODOO_DATABASE_USER=bn_odoo --env ODOO_DATABASE_PASSWORD=bitnami --env ODOO_DATABASE_HOST=odoo-test-postgresql --env ODOO_DATABASE_PORT_NUMBER=5432 --network odoo-test-network --volume $ODOO_VOLUME:/bitnami/odoo ghcr.io/craftschoolship/odoo-test:16.0.1-sat
docker stop odoo-test-postgresql
docker rm odoo-test-postgresql odoo-test
```
###### Usage
1. Save this in same folder as your module
```
.
├── my_module
└── test.sh
```
2. Export the env variables
```sh
export ODOO_MODULE_NAME=my_module
export ODOO_VOLUME=path/to/odoo/volume
```
3. Run the script
```sh
sh ./test.sh
```
