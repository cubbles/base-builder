# Base-Builder
Zweck: Tool für das Bauen von Docker-Images

## Commandline-Usage

### List Options
    $ ./bin/run.sh

### Build and tag images
    # $ ./bin/run.sh build <image name | all> <tag>
    $ $ ./bin/run.sh build docker.webblebase:4444.net/base/gateway 1.0
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


