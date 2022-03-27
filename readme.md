# docker-icecast
Icecast implemented in Docker
=============================

Synopsis
--------

Docker-icecast implements Icecast V2 in a lightweight docker container. The Alpine Linux icecast package is used. Arguments are used to build an environment substitution configuration file. Each run replaces environment variables in the built icecastenv.xml file.

Overview
--------
With the dockerfile in an empty directory and run the following command.
'docker build -p 8000:8000 mattrock/docker'