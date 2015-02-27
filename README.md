# Base-Builder
Zweck: Tool für das Bauen von Docker-Images

## Commandline-Usage

### List Options
    $ ./bin/run.sh
    Prepare environment ...
    ======================
    PATH=/mnt/sda1/projects.webbles/git/base/base-builder/opt/node_i686/bin:/home/docker/.local/bin:/usr/local/sbin:/usr/local/bin:/apps/bin:/usr/sbin:/usr/bin:/sbin:/bin
    node version = v0.10.35

    Do processing ...
    =================
    usage: ./bin/run.sh { build [image | all] | status [cluster] }
    docker@boot2docker:/mnt/sda1/projects.webbles/git/base/base-builder$


### Build and (optionally) tag images
    # $ ./bin/run.sh build <image name | all> <optional: tag>
    $ ./bin/run.sh build docker.webblebase.net/base/gateway 1.0

    Prepare environment ...
    ======================
    PATH=/mnt/sda1/projects.webbles/git/base/base-builder/opt/node_i686/bin:/home/docker/.local/bin:/usr/local/sbin:/usr/local/bin:/apps/bin:/usr/sbin:/usr/bin:/sbin:/bin
    node version = v0.10.35

    Do processing ...
    =================
    building image docker.webblebase.net/base/gateway:1.0-SNAPSHOT
    Using /mnt/sda1/projects.webbles/git/base/base-builder/etc/gateway as build context
    ADD and COPY directives must be relative to the above directory

    Building image docker.webblebase.net/base/gateway:1.0-SNAPSHOT
    Uploading compressed context...
    Step 0 : FROM nginx:1.7.9
     ---> 4b5657a3d162
    [...]


## PreRequisites
1. Linux OS
2. Docker muss installiert sein.

Die restliche Laufzeitumgebung (node.js und das npm-Modul [Decking] (http://decking.io)) bringt das Tool mit (Siehe [opt/] (/opt/)).

## Background-Infos
### Directories
 - bin ... enthält Scripte für dieses Tools.
 - etc ... enthält die Konfiguration.
 - opt ... enthält 3rd-Party Tools, die zur Laufzeit benötigt werden.

### Images
Die für den Build verfügbaren Images sind in [etc/decking.json] (/etc/decking.json) aufgeführt und die entsprechenden Dockerfiles verlinkt.


