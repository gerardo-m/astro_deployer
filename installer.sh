#! /bin/bash

sudo mkdir -p /opt/adep/

cd /opt/adep/
sudo wget https://raw.githubusercontent.com/gerardo-m/astro_deployer/refs/heads/master/adep.sh
sudo wget https://raw.githubusercontent.com/gerardo-m/astro_deployer/refs/heads/master/adep-add.sh

sudo chmod +x adep.sh
sudo chmod +x adep-add.sh

if [[ ! ":$PATH:" == *":/opt/adep:"* ]]; then
    echo 'export PATH="$PATH:/opt/adep"' >> ~/.bashrc
fi

source ~/.bashrc

cd -

