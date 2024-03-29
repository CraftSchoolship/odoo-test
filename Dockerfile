FROM docker.io/bitnami/odoo:16

COPY ./entrypoint.sh /opt/bitnami/scripts/odoo/entrypoint.sh

EXPOSE 3000 8069 8072

ENTRYPOINT [ "/opt/bitnami/scripts/odoo/entrypoint.sh" ]
