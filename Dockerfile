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

# Install envsubst
RUN set -x && \
    apk add --no-cache libintl && \
    apk add --no-cache --virtual build_deps &&  \
    apk add --no-cache gettext && \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps

RUN apk add mailcap icecast
#USER icecast:icecast
# COPY [--chown=icecast:icecast] icecastenv.xml /icecastenv.xml
# COPY [--chown=icecast:icecast] entrypoint.sh /entrypoint.sh
COPY icecastenv.xml /icecastenv.xml
COPY entrypoint.sh /entrypoint.sh
EXPOSE 8000
# EXPOSE 8443
VOLUME ["/data"]
ENTRYPOINT ["/entrypoint.sh"]
CMD /usr/bin/icecast -c /data/icecast.${HOSTNAME}.xml
