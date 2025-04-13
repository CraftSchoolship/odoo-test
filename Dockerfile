FROM ghcr.io/craftschoolship/odoo:20250306-114213

RUN /opt/bitnami/odoo/venv/bin/pip3 install coverage

RUN echo 'jwt_secret_key=1234' >> /opt/bitnami/scripts/odoo/bitnami-templates/odoo.conf.tpl

COPY ./entrypoint.sh /opt/bitnami/scripts/odoo/entrypoint.sh

EXPOSE 3000 8069 8072

ENTRYPOINT [ "/opt/bitnami/scripts/odoo/entrypoint.sh" ]
