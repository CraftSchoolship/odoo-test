#!/bin/bash
# Copyright VMware, Inc.
# SPDX-License-Identifier: APACHE-2.0

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Odoo environment
. /opt/bitnami/scripts/odoo-env.sh

# Load libraries
. /opt/bitnami/scripts/libbitnami.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libodoo.sh

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

declare cmd="${ODOO_BASE_DIR}/bin/odoo"
declare -a args=("-i" "$MODULES_TO_INSTALL" "--test-tags" "$ODOO_TEST_TAGS" "--stop-after-init" "--config" "$ODOO_CONF_FILE" "$@")

info "** Starting Odoo **"
if am_i_root; then
    exec_as_user "$ODOO_DAEMON_USER" "$cmd" "${args[@]}"
else
    exec "$cmd" "${args[@]}"
fi
