# odoo-test
![odoo](https://img.shields.io/badge/odoo-_16-844FBA)

A Bitnami Odoo Container for running Odoo Tests

## Update
A new environment variable was added to the image, now you can add a custom shell script for setting up the test dependencies, i.e. installing pip libraries, apt packages and more...

This can be done through the variable `SETUP_SHELL_SCRIPT` that takes raw shell (not a file), Example:
```sh
SETUP_SHELL_SCRIPT="/opt/bitnami/odoo/venv/bin/pip3 install redis"
```

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
3. Create an Odoo Test container to run your tests
```sh
docker run -t --name odoo-test \
  --env ODOO_DATABASE_ADMIN_PASSWORD=bitnami \
  --env ODOO_DATABASE_NAME=bitnami_odoo \
  --env ODOO_DATABASE_USER=bn_odoo \
  --env ODOO_DATABASE_PASSWORD=bitnami \
  --env ODOO_DATABASE_HOST=odoo-test-postgresql \
  --env ODOO_DATABASE_PORT_NUMBER=5432 \
  --network odoo-test-network \
  --volume /path/to/odoo/addons:/bitnami/testing/addons \
  ghcr.io/craftschoolship/odoo-test:16.2.0
```
> **TODO** replace `/path/to/odoo/addons` with the path to the folder containing the modules you want to test


### Bash Script
```sh
# Create docker network
docker network create odoo-test-network

# Create a PostgreSQL container from Bitnami
docker run -d --name odoo-test-postgresql \
  --env POSTGRESQL_USERNAME=bn_odoo \
  --env POSTGRESQL_PASSWORD=bitnami \
  --env POSTGRESQL_DATABASE=bitnami_odoo \
  --network odoo-test-network \
  bitnami/postgresql:16.2.0

# Create an Odoo Test container to run your tests
docker run -t --name odoo-test \
  --env ODOO_DATABASE_ADMIN_PASSWORD=bitnami \
  --env ODOO_DATABASE_NAME=bitnami_odoo \
  --env ODOO_DATABASE_USER=bn_odoo \
  --env ODOO_DATABASE_PASSWORD=bitnami \
  --env ODOO_DATABASE_HOST=odoo-test-postgresql \
  --env ODOO_DATABASE_PORT_NUMBER=5432 \
  --network odoo-test-network \
  --volume .:/bitnami/testing/addons \
  ghcr.io/craftschoolship/odoo-test:16.2.0

# Clean docker resources
docker stop odoo-test-postgresql
docker rm odoo-test-postgresql odoo-test
docker network rm odoo-test-network

```
###### Usage
1. Save this in same folder as your module
```
.
├── my_module
└── test.sh
```
2. Make the file executable
```sh
chmod ugao+x test.sh
```
3. Run the script
```sh
<sudo> ./test.sh
```
