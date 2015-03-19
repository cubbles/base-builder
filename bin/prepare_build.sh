#!/bin/sh
CURRENT_DIR=$(pwd)
RESOURCE_DIR_NAME=setup-resources
APP_DIR_NAME=setup-resources

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

prepare_webpackagesearch(){
  cd webpackagesearch/opt/webpackagesearch

  # webpackagesearch
  _cleanFolder $APP_DIR_NAME
  WEBPACKAGESEARCH=webpackagesearch
  echo "Accessing Git ... download '$WEBPACKAGESEARCH'"
  sudo GIT_SSL_NO_VERIFY=true git clone https://pmt.incowia.de/webble/r/base/webpackagesearch/$WEBPACKAGESEARCH.git $APP_DIR_NAME
  echo "Accessing Git ... done."
  cd $APP_DIR_NAME && sudo rm -rf .git

  # couchapp-webpackagesearch
  _cleanFolder $RESOURCE_DIR_NAME
  COUCHAPPWEBPACKAGESEARCH=couchapp-webpackagesearch
  cd $RESOURCE_DIR_NAME
  echo "Accessing Git ... download '$COUCHAPPWEBPACKAGESEARCH'"
  sudo GIT_SSL_NO_VERIFY=true git clone https://pmt.incowia.de/webble/r/base/webpackagesearch/$COUCHAPPWEBPACKAGESEARCH.git
  echo "Accessing Git ... done."
  cd $COUCHAPPWEBPACKAGESEARCH && sudo rm -rf .git
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