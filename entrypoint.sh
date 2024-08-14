#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

echo "   ______           ______  _____      __                __     __    _      "
echo "  / ____/________ _/ __/ /_/ ___/_____/ /_  ____  ____  / /____/ /_  (_)___  "
echo " / /   / ___/ __ \`/ /_/ __/\__ \/ ___/ __ \/ __ \/ __ \/ / ___/ __ \/ / __ \ "
echo "/ /___/ /  / /_/ / __/ /_ ___/ / /__/ / / / /_/ / /_/ / (__  ) / / / / /_/ / "
echo "\____/_/   \__,_/_/  \__//____/\___/_/ /_/\____/\____/_/____/_/ /_/_/ .___/  "
echo "  ____     __           ______        __  _                      /_/         "
echo " / __ \___/ /__  ___   /_  __/__ ___ / /_(_)__  ___ _"
echo "/ /_/ / _  / _ \/ _ \   / / / -_|_-</ __/ / _ \/ _ \`/"
echo "\____/\_,_/\___/\___/  /_/  \__/___/\__/_/_//_/\_, / "
echo "                                              /___/  "
echo ""

# Load Odoo environment
. /opt/bitnami/scripts/odoo-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libodoo.sh

# Check if the SETUP_SHELL_SCRIPT variable is set
if [ -n "${SETUP_SHELL_SCRIPT:-}" ]; then
    # Write the content of the SETUP_SHELL_SCRIPT variable to a temporary file
    echo "$SETUP_SHELL_SCRIPT" > /tmp/script.sh
    chmod +x /tmp/script.sh

    # Execute the temporary script
    info "** Executing the Setup Script... **"
    /tmp/script.sh
    info "** Setup Script execution finished! **"
fi

print_welcome_page

/opt/bitnami/scripts/postgresql-client/setup.sh
/opt/bitnami/scripts/odoo/setup.sh
/post-init.sh
info "** Odoo setup finished! **"

echo ""

# Check if the source directory exists
if [ ! -d /bitnami/testing/addons ]; then
    echo "Error: Source directory for testing modules does not exist."
    echo "Skipping tests as none can be located"
    exit 1
fi

# Copy all folders and their contents recursively
cp -r /bitnami/testing/addons/* /bitnami/odoo/addons

# Get the modules to install
MODULES_TO_INSTALL=$(find /bitnami/odoo/addons -mindepth 1 -maxdepth 1 -type d -printf '%f,')
# Remove the trailing comma
MODULES_TO_INSTALL=${MODULES_TO_INSTALL%,}

# Get the test tags
ODOO_TEST_TAGS=$(find /bitnami/odoo/addons -mindepth 1 -maxdepth 1 -type d -printf '/%f,')
# Remove the trailing comma and wrap with quotes
ODOO_TEST_TAGS="${ODOO_TEST_TAGS%,}"

info "** Tests setup finished! **"
echo ""

# Stop exit on error to allow tests to fail without breaking the container
set +o errexit
set +o pipefail

info "** Starting Odoo **"
/opt/bitnami/odoo/venv/bin/coverage run --data-file=/bitnami/odoo/.coverage ${ODOO_BASE_DIR}/bin/odoo -i $MODULES_TO_INSTALL --test-tags $ODOO_TEST_TAGS --stop-after-init --log-level=test --config $ODOO_CONF_FILE

echo ""
info "** Test Results **"
echo ""
/opt/bitnami/odoo/venv/bin/coverage report --data-file=/bitnami/odoo/.coverage
