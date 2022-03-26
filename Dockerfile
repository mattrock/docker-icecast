# syntax=docker/dockerfile:1.3-labs
FROM python:3
# Icecast limits configured at build
ARG location=Earth
ARG public_admin="icemaster@localhost"
ARG clients=100
ARG sources=2
ARG queue_size=524288
ARG client_timeout=30
ARG header_timeout=15
ARG source_timeout=10
ARG burst_on_connect=1
ARG burst_size=65535
# Build icecastenv.xml
RUN python3 <<EOF > icecastenv.xml
import os 
import xml.etree.ElementTree as ET
from xml.dom import minidom
iceconf = ET.Element('icecast')
comment = ET.Comment('by MattRock [matt.rockwell@gmail.com] 3/22')
iceconf.append(comment)
admin = ET.SubElement(iceconf, 'admin')
admin.text = os.environ['public_admin']
authentication = ET.SubElement(iceconf, 'authentication')
sourcepassword = ET.SubElement(authentication, 'source-password')
sourcepassword.text = '\${source_password}'
relaypassword = ET.SubElement(authentication, 'relay-password')
relaypassword.text = '\${relay_password}'
adminuser = ET.SubElement(authentication, 'admin-user')
adminuser.text = '\${admin_user}'
adminpassword = ET.SubElement(authentication, 'admin-password')
adminpassword.text = '\${admin_password}'
fileserve = ET.SubElement(iceconf, 'fileserve')
fileserve.text = '1'
hostname = ET.SubElement(iceconf, 'hostname')
hostname.text = '\${HOSTNAME}'
httpheaders = ET.SubElement(iceconf, 'http-headers')
header = ET.SubElement(httpheaders,'header')
header.set('name','Access-Control-Allow-Origin')
header.set('value','*')
limits = ET.SubElement(iceconf, 'limits')
clients = ET.SubElement(limits, 'clients')
clients.text=os.environ['clients']
sources = ET.SubElement(limits, 'sources')
sources.text=os.environ['sources']
queuesize = ET.SubElement(limits, 'queue-size')
queuesize.text=os.environ['queue_size']
clienttimeout = ET.SubElement(limits, 'client-timeout')
clienttimeout.text=os.environ['client_timeout']
headertimeout = ET.SubElement(limits, 'header-timeout')
headertimeout.text=os.environ['header_timeout']
sourcetimeout = ET.SubElement(limits, 'source-timeout')
sourcetimeout.text=os.environ['source_timeout']
burstonconnect = ET.SubElement(limits, 'burst-on-connect')
burstonconnect.text=os.environ['burst_on_connect']
burstsize = ET.SubElement(limits, 'burst-size')
burstsize.text=os.environ['burst_size']
listensocket = ET.SubElement(iceconf, 'listen-socket')
port = ET.SubElement(listensocket, 'port')
port.text = '8000'
location = ET.SubElement(iceconf, 'location')
location.text = os.environ['location']
logging = ET.SubElement(iceconf, 'logging')
accesslog = ET.SubElement(logging, 'accesslog')
accesslog.text='-'
errorlog = ET.SubElement(logging, 'errorlog')
errorlog.text='-'
playlistlog = ET.SubElement(logging, 'playlistlog')
playlistlog.text='-'
loglevel = ET.SubElement(logging, 'loglevel')
loglevel.text='3'
paths = ET.SubElement(iceconf, 'paths')
adminroot = ET.SubElement(paths, 'adminroot')
adminroot.text = '/admin'
alias = ET.SubElement(paths, 'alias')
alias.set('source','/')
alias.set('destination','/status.xsl')
basedir = ET.SubElement(paths, 'basedir')
basedir.text = '/data'
webroot = ET.SubElement(paths, 'webroot')
webroot.text = '/web'
security = ET.SubElement(iceconf, 'security')
chroot = ET.SubElement(security, 'chroot')
chroot.text = '1'
changeowner = ET.SubElement(security, 'changeowner')
user = ET.SubElement(changeowner, 'user')
user.text = 'icecast'
group = ET.SubElement(changeowner, 'group')
group.text = 'icecast'
print (minidom.parseString(ET.tostring(iceconf, 'utf-8')).toprettyxml(indent="  "))
EOF

FROM alpine:latest
LABEL maintainer="matt.rockwell@gmail.com"
# Administration defaults
ENV admin_user="admin"
ENV admin_password="hackme"
ENV source_password="hackme"
ENV relay_password="hackme"
# Copy the built config template to this image
COPY --from=0 /icecastenv.xml ./
# Install envsubst and then dump the build dependencies
RUN set -x && \
    apk add --no-cache libintl && \
    apk add --no-cache --virtual build_deps &&  \
    apk add --no-cache gettext && \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps
# Install icecast and mime types
## Alpine icecast package creates icecast user & group
RUN apk add --no-cache mailcap icecast
# Build entrypoint.sh 
## check for needed files in /data to chroot
## then replace environment variables on launch
RUN cat <<EOF > entrypoint.sh
#!/bin/sh
## by MattRock [matt.rockwell@gmail.com] 3/22
# check for a mime.types file in the etc folder
if [ ! -d "/data/etc" ]
then mkdir /data/etc 
fi
if [ ! -e "/data/etc/mime.types" ]
then cp /etc/mime.types /data/etc/ 
fi
# Backup last config file if exists
if [ -e "/data/icecast.${HOSTNAME}.xml" ]
then cp /data/icecast.${HOSTNAME}.xml /data/icecast.${HOSTNAME}.last.xml 
fi
# If no web folder exists in /data, copy web files to match <webroot> in <paths>.
if [ ! -d "/data/web" ]
then cp -R /usr/share/icecast/web/ /data 
fi
# If no admin folder exists in /data, copy admin files to match <adminroot> in <paths>.
if [ ! -d "/data/admin" ]
then cp -R /usr/share/icecast/admin/ /data
fi
# Substitute environment variables from the iceceast config template
envsubst < /icecastenv.xml > /data/icecast.\${HOSTNAME}.xml
# Exececute provided arguments
exec "\$@"
EOF
RUN chmod a+x entrypoint.sh
EXPOSE 8000
# EXPOSE 8443
VOLUME ["/data"]
ENTRYPOINT ["/entrypoint.sh"]
CMD /usr/bin/icecast -c /data/icecast.${HOSTNAME}.xml
