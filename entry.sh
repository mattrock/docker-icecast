#!/bin/sh
# by MattRock [matt.rockwell@gmail.com] 3/22

# Backup last config
if test -f "/data/icecast.xml"; then
    cp /data/icecast.xml /data/icecast_last.xml
fi

# Substitute environment variables
envsubst < /icecastenv.xml > /data/icecast.xml

# Launch icecast with resulting file
/usr/bin/icecast -c /data/icecast.xml