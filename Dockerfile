FROM odoo:17

USER root

WORKDIR /opt/odoo

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

COPY . /opt/odoo/runbot
COPY runbot_builder /opt/odoo/runbot_builder
COPY scripts /opt/odoo/scripts

ENV ADDONS_PATH=/usr/lib/python3/dist-packages/odoo/addons,/opt/odoo/runbot

RUN mkdir -p /var/log/odoo && \
    chmod +x /opt/odoo/scripts/*.sh

USER odoo

ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]
