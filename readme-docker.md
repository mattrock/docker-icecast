# mattrock/icecast

Icecast implemented from the environment.

## Getting Started

These instructions will cover usage information and for the docker mattrock/icecast container.

### Usage

#### Container Parameters

Starting the container with all defaults.

```shell
docker run -p 8000:8000 mattrock/icecast:v2.4.4
```
### Docker Compose
    version: "3.9"
    services:
    app:
        image: mattrock/icecast
        environment: 
        sources: 3
        clients: 200
        location: On The Lake
        publicadmin: mattrock@localhost
        adminpassword: admin
        sourcepassword: source
        relaypassword: relay
        volumes: 
        - ./data:/data
        ports: 
        - "8000:8000"

#### Build Arguments
Used for icecast limits. Defaults are derived from the stock default icecast.xml file.

* `queuesize` - Default 524288
* `clienttimeout` - Default 30
* `headertimeout` - Default 15
* `sourcetimeout` - Default 10
* `burstonconnect` - Default 1
* `burstsize` - Default 65535
* `loglevel` - Default Info. May be set to debug or 4, info or 3, warn or 2, error or 1

#### Environment Variables

* `TZ` - Timezone in TZ format 'America/Chicago'
* `clients` - Max number of clients
* `sources` - Max number of sources
* `location` - Public location
* `publicadmin` - Public administrator
* `adminuser` - Username for the administrative user
* `adminpassword` - Password for the administrative user
* `sourcepassword` - Password for conneccting sources
* `relaypassword` - Password for connecting relays

#### Volumes

* `/data` - Icecast config xml location

#### Useful File Locations

* `/icecastenv.xml` - File read by the entrypoint script. Environment variables are substituted, and output is saved as /data/icecast.$HOSTNAME.xml and used to start the icecast process.
  
* `/entrypoint.sh` - Container entrypoint which runs the environment variable substitution against the /icecastenv.xml file created during build.

## Built With

* Python3 / xml.etree xml.dom.minidom
* Alpine 3 / [world]:icecast

## Find Us

* [GitHub](https://github.com/mattrock/docker-icecast)

## Authors

* **Matt Rockwell** - [MattRock](https://github.com/mattrock)

## License

This project is licensed under the BSD V2 License,