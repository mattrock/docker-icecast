#!/bin/sh
# by MattRock [matt.rockwell@gmail.com] 3/22

# set > run.txt

# Backup last config
if test -f "/data/icecast.xml"; then
    cp /data/icecast.xml /data/icecast_${HOSTNAME}_backup.xml
fi

# Substitute environment variables
envsubst < /build/icecastenv.xml > /data/icecast_${HOSTNAME}.xml

# Launch icecast with resulting file
/usr/bin/icecast -c /data/icecast_${HOSTNAME}.xml