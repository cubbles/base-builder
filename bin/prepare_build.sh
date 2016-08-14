#!/bin/sh
RESOURCE_DIR_NAME=setup-resources
APP_DIR_NAME=app

# --------- functions ---------
prepare_coredatastore(){
  cd base.coredatastore/opt/coredatastore
  if [ -d $RESOURCE_DIR_NAME ]; then {
    echo "Remove old setup-resources ..."
    sudo rm -r $RESOURCE_DIR_NAME
    echo "Remove old setup-resources ... done."
  }
  fi
  sudo mkdir $RESOURCE_DIR_NAME && cd $RESOURCE_DIR_NAME
  echo "Accessing Git ..."
  sudo GIT_SSL_NO_VERIFY=true git clone https://base-builder:k5TR6J25wQDuT37anAqE@pmt.incowia.de/webble/r/client/utilities/couchapp_crc-utils.git
  sudo GIT_SSL_NO_VERIFY=true git clone https://base-builder:k5TR6J25wQDuT37anAqE@pmt.incowia.de/webble/r/base/authentication/base-couchapps_authentication-utils.git
  sudo GIT_SSL_NO_VERIFY=true git clone https://base-builder:k5TR6J25wQDuT37anAqE@pmt.incowia.de/webble/r/base/coredatastore/base-couchapp_webpackage-validator.git
  sudo GIT_SSL_NO_VERIFY=true git clone https://base-builder:k5TR6J25wQDuT37anAqE@pmt.incowia.de/webble/r/base/webpackagesearch/base-couchapp-artifactsearch.git
  echo "Accessing Git ... done."
  cd couchapp_crc-utils && sudo GIT_SSL_NO_VERIFY=true git fetch && sudo git checkout v0.3.1 && sudo rm -rf .git && cd ..
  cd base-couchapps_authentication-utils && sudo GIT_SSL_NO_VERIFY=true git fetch && sudo git checkout v0.2.1 && sudo rm -rf .git && cd ..
  cd base-couchapp_webpackage-validator && sudo GIT_SSL_NO_VERIFY=true git fetch && sudo git checkout v0.5.1 && sudo rm -rf .git && cd ..
  cd base-couchapp-artifactsearch && sudo GIT_SSL_NO_VERIFY=true git fetch && sudo git checkout v0.5.1 && sudo rm -rf .git
}

prepare_authentication(){
  cd base.authentication/opt/authentication
  if [ -d $RESOURCE_DIR_NAME ]; then {
    echo "Remove old setup-resources ..."
    sudo rm -r $RESOURCE_DIR_NAME
    echo "Remove old setup-resources ... done."
  }
  fi
  sudo mkdir $RESOURCE_DIR_NAME && cd $RESOURCE_DIR_NAME
  echo "Accessing Git ..."
  sudo GIT_SSL_NO_VERIFY=true git clone https://base-builder:k5TR6J25wQDuT37anAqE@pmt.incowia.de/webble/r/base/authentication/base-authentication-service.git
  echo "Accessing Git ... done."
  cd base-authentication-service && sudo GIT_SSL_NO_VERIFY=true git fetch && sudo git checkout v0.1.0 && sudo rm -rf .git && cd ..
}

prepare_userprofilemanagement(){
  cd base.userprofilemanagement/opt/userprofilemanagement
  if [ -d $RESOURCE_DIR_NAME ]; then {
    echo "Remove old setup-resources ..."
    sudo rm -r $RESOURCE_DIR_NAME
    echo "Remove old setup-resources ... done."
  }
  fi
  sudo mkdir $RESOURCE_DIR_NAME && cd $RESOURCE_DIR_NAME
  echo "Accessing Git ..."
  sudo GIT_SSL_NO_VERIFY=true git clone https://base-builder:k5TR6J25wQDuT37anAqE@pmt.incowia.de/webble/r/base/userprofilemanagement/base-userprofilemanagement-service.git
  echo "Accessing Git ... done."
  cd base-userprofilemanagement-service && sudo GIT_SSL_NO_VERIFY=true git fetch && sudo git checkout v0.2.1 && sudo rm -rf .git && cd ..
}

_cleanFolder () {
  if [ -d $1 ]; then {
    echo "Clean $1 ..."
    sudo rm -r $1
    echo "Clean $1 ... done."
  }
  fi
  sudo mkdir $1
}