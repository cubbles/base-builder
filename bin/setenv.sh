#!/bin/sh
CURRENT_DIR=$(pwd)
NODE_x86_64=$CURRENT_DIR/opt/node_x86_64
NODE_i686=$CURRENT_DIR/opt/node_i686
NODE_Found=0
# if the x86_64 version of Node.js is working -> use it!
if [ -x $NODE_x86_64/bin/node ]; then
  $NODE_x86_64/bin/node -v >/dev/null 2>&1
  if [ $? = 0 ]; then
    export PATH=$CURRENT_DIR/opt/node_x86_64/bin:$PATH
    NODE_Found=1
  fi
fi
# if the i686 version of Node.js is working -> use it!
if [ $NODE_Found = 0 ] && [ -x "$NODE_i686"/bin/node ]; then
  $NODE_i686/bin/node -v >/dev/null 2>&1
  if [ $? = 0 ]; then
    export PATH=$CURRENT_DIR/opt/node_i686/bin:$PATH
    NODE_Found=1
  fi
fi
# neither x86_64 nor i686 node are working!
if [ $NODE_Found != 1 ]; then
  echo "No active Node.js found. Please check the installation".
fi

BUILDER_CLI_DIR=$CURRENT_DIR/opt/builder-cli
export BUILDER_CLI_DIR

# --------- functions ---------
showEnvironment(){
	echo "PATH=$PATH"
	echo "node version = $(node -v)"
}
