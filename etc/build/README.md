Each subfolder contains the resources needed to build the corresponding docker-image.

## base
This image provides a commandline-interface to setup and control a Cubbles Base instance on the same host.

## base.abstract-node
This image works as a parent-image other "base*" images can be build on top of. It provides the operating system, nodejs and some basic tools we want to be available within each container.

## base.*
Other images provide sub-services of a Cubbles Base - each running within a separate docker container.
For details please see the ```README.md``` file within their subfolders.