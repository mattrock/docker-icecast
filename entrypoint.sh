#!/bin/sh
# by MattRock [matt.rockwell@gmail.com] 3/22

# Backup last config
if test -f "/data/icecast_${HOSTNAME}.xml"; then
    cp /data/icecast_${HOSTNAME}.xml /data/icecast_${HOSTNAME}_backup.xml
fi

# Substitute environment variables
envsubst < /build/icecastenv.xml > /data/icecast_${HOSTNAME}.xml

# Launch icecast with resulting file
/usr/bin/icecast -c /data/icecast_${HOSTNAME}.xml