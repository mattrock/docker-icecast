# docker-icecast
Icecast implemented in Docker
=============================

Synopsis
--------

Docker-icecast implements Icecast V2 in a lightweight docker container. The Alpine Linux icecast package is used. Arguments are used to build an environment substitution configuration file. Each run replaces environment variables in the built icecastenv.xml file and the process is run in a chroot environment.

Quickstart
----------
With the dockerfile in an empty directory and run the following command.

    docker build -t mattrock/icecast .
    docker run -p 8000:8000

A /data volume will be created and all web and admin templates will be copied to that 


Build occurs in two stages. First, a virtual python3 image and xml.etree package is used to build an icecastenv.xml file from scratch. Build arguments are used to populate Icecast's limits. Environment variable names are substituted for ENV variables substituted during run.

    ARG queuesize=524288
    ARG clienttimeout=30
    ARG headertimeout=15
    ARG sourcetimeout=10
    ARG burstonconnect=1
    ARG burstsize=65535

Override any argument on build from the command line to set the parameter in the icecastenv.xml file.

    docker build \
    --build-arg clienttimeout=60 \
    --build-arg sourcetimeout=15 \
    -p 8000:8000 .

After