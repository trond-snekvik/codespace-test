#!/usr/bin/env bash

# NOTE: This should always be the latest version, but the URL does not support
#       fetching the latest dynamically at the moment.
COMMAND_LINE_TOOLS_VERSION="10-22-0/nrf-command-line-tools_10.22.0"
SDK_VERSION=${SDKVERSION}
PROJECT_TYPE=${PROJECTTYPE}
INITIALIZE_WORKSPACE_PROJECT=${INITIALIZEWORKSPACEPROJECT}

set -euo pipefail

apt-get update
apt-get install --no-install-recommends --yes \
  ca-certificates \
  udev \
  wget

echo "Installing nRF Command Line Tools"
# https://www.nordicsemi.com/Products/Development-tools/nrf-command-line-tools/download
wget https://nsscprodmedia.blob.core.windows.net/prod/software-and-other-downloads/desktop-software/nrf-command-line-tools/sw/versions-10-x-x/${COMMAND_LINE_TOOLS_VERSION}_amd64.deb -O /root/nrf-command-line-tools.deb
apt-get install -y /root/nrf-command-line-tools.deb
apt-get install -y /opt/nrf-command-line-tools/share/JLink_Linux_*.deb
rm /root/nrf-command-line-tools.deb /opt/nrf-command-line-tools/share/JLink_Linux_*.deb

echo "Installing nrfutil"
# https://www.nordicsemi.com/Products/Development-tools/nrf-util
wget "https://developer.nordicsemi.com/.pc-tools/nrfutil/x64-linux/nrfutil" -O /usr/bin/nrfutil
chmod +x /usr/bin/nrfutil

echo "Installing toolchain-manager (this might take a while)"
nrfutil install toolchain-manager
nrfutil toolchain-manager install --ncs-version "${SDK_VERSION}"
nrfutil toolchain-manager env --as-script sh >> /etc/envvars
echo "source /etc/envvars" >> /etc/profile
echo "source /etc/envvars" >> /etc/bash.bashrc

if [ "$PROJECT_TYPE" == "workspace" ] && [ -n "$INITIALIZE_WORKSPACE_PROJECT" ]; then
  install -m755 ./initialize-workspace-application.sh /usr/bin
elif [ "$PROJECT_TYPE" == "freestanding" ]; then
  cat <<- EOF > /usr/bin/initialize-workspace-application.sh
    #!/usr/bin/env bash
    echo "Freestanding project, skipping workspace initialization"
EOF

  chmod 755 /usr/bin/initialize-workspace-application.sh

  echo "Installing nRF Connect SDK ${SDK_VERSION}"
  # https://developer.nordicsemi.com/nRF_Connect_SDK/doc/latest/nrf/getting_started/installing.html
  mkdir /ncs
  pushd /ncs

  set +u
  source /etc/envvars
  set -u

  west init -m https://github.com/nrfconnect/sdk-nrf --mr "${SDK_VERSION}"
  west update -n -o=--depth=1
  west zephyr-export
  popd
fi
