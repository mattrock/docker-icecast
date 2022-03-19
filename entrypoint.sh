#!/bin/sh
##
## by MattRock [matt.rockwell@gmail.com] 3/22 ##
##
# cp /etc/mime.types /data/etc/mime.types

# Backup last config
if ["/data/icecast.${HOSTNAME}.xml"]; then
  cp /data/icecast.${HOSTNAME}.xml /data/icecast.${HOSTNAME}.last.xml
fi

# If no web folder exists in /data,
# copy web files to match <webroot> in <paths>.
if [ ! -d "/data/web" ]; then
  cp -R /usr/share/icecast/web/ /data
fi

# If no admin folder exists in /data,
# copy admin files to match <adminroot> in <paths>.
if [ ! -d "/data/admin" ]; then
  cp -R /usr/share/icecast/admin/ /data
fi

# check for a mime.types file in the etc folder
if [ ! -d "/data/etc" ]; then 
  mkdir /data/etc
fi
if [ ! -e "/data/etc/mime.types" ]; then 
  cp /etc/mime.types /data/etc/
fi

# Substitute environment variables from the iceceast config template
envsubst < /icecastenv.xml > /data/icecast.${HOSTNAME}.xml

# Exececute provided arguments
exec "$@"