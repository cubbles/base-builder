#!/bin/sh
# Note: To override or extend the config, please create/use setenv-local.sh
CURRENT_DIR=$(pwd)
MACHINE_TYPE=$(uname -m)
NODE_NAME=$(uname -n)
# Note: boot2docker comes with a 32-bit user-space on a 64-bit kernel
if [ ${MACHINE_TYPE} = "x86_64" ] && [ ${NODE_NAME} != "boot2docker" ]; then
  # 64-bit stuff here
  export PATH=$CURRENT_DIR/opt/node_x86_64/bin:$PATH
else
  # 32-bit stuff here
  export PATH=$CURRENT_DIR/opt/node_i686/bin:$PATH
fi
# provide node_modules separately, because they are independant from the kernel-platform
export NODE_MODULE_DECKING=$CURRENT_DIR/opt/node_modules/decking

# --------- functions ---------
showEnvironment(){
	echo "PATH=$PATH"
}
