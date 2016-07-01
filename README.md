# Base-Builder
Zweck: Tool für das Bauen von Docker-Images

## Commandline-Usage

1. Via ssh in die docker-vm verbinden.
2. Lokales Entwicklerverzeichnis mounten.
3. In das Root-Verzeichnis dieses Projekts wechseln.

### List Options
    $ ./bin/run.sh

### Build and tag images
    # $ ./bin/run.sh build <image name> <tag>
    $ $ ./bin/run.sh build cubbles/base.gateway 1.0
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


