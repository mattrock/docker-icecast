FROM alpine:latest
LABEL maintainer="matt.rockwell@gmail.com"

# Administration
ENV location="Earth"
ENV public_admin="icemaster@localhost"
ENV admin_user="admin"
ENV admin_password="hackme"
ENV source_password="hackme"
ENV relay_password="hackme"

# Limits
ENV clients=250
ENV sources=4
ENV queue_size=524288
ENV client_timeout=30
ENV header_timeout=15
ENV source_timeout=10
ENV burst_on_connect=1
ENV burst_size=65535

# Install icecast
RUN apk add icecast mailcap

# Install envsubst
RUN set -x && \
    apk add --update libintl && \
    apk add --virtual build_deps gettext &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps

# Create datastore and populate
VOLUME /data
COPY icecastenv.xml /icecastenv.xml
COPY entry.sh /entry.sh
ENTRYPOINT ["/entry.sh"]
EXPOSE 8000
EXPOSE 8443