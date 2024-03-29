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

declare cmd="${ODOO_BASE_DIR}/bin/odoo"
declare -a args=("--test-tags" "$ODOO_TEST_TAGS" "--stop-after-init" "--config" "$ODOO_CONF_FILE" "$@")

info "** Starting Odoo **"
if am_i_root; then
    exec_as_user "$ODOO_DAEMON_USER" "$cmd" "${args[@]}"
else
    exec "$cmd" "${args[@]}"
fi
