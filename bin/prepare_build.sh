#!/bin/sh
CURRENT_DIR=$(pwd)
RESOURCE_DIR_NAME=setup-resources

# --------- functions ---------
prepare_coredatastore(){
  cd coredatastore/opt/coredatastore
  if [ -d $RESOURCE_DIR_NAME ]; then {
    echo "Remove old setup-resources ..."
    sudo rm -r $RESOURCE_DIR_NAME
    echo "Remove old setup-resources ... done."
  }
  fi
  sudo mkdir $RESOURCE_DIR_NAME && cd $RESOURCE_DIR_NAME
  echo "Accessing Git ..."
  sudo GIT_SSL_NO_VERIFY=true git clone https://pmt.incowia.de/webble/r/client/utilities/couchapp_crc-utils.git
  echo "Accessing Git ... done."
  cd couchapp_crc-utils && sudo rm -rf .git
}