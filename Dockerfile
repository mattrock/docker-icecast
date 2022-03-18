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
ENV clients=100
ENV sources=2
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
RUN mkdir /build
COPY icecastenv.xml /build/icecastenv.xml
COPY entrypoint.sh /build/entrypoint.sh

# RUN set > build.txt

ENTRYPOINT ["/build/entrypoint.sh"]
EXPOSE 8000
# EXPOSE 8443