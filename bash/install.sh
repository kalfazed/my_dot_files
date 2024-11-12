#!/usr/bin/bash

source ../hostname.sh
mkdir -p ~/.config/bash
cp -r * ~/.config/bash
sudo cp -r ./packages/bin/* /usr/local/bin

echo "HOST=['${hostname}']" >> ~/.config/bash/variables/host_name.sh

echo "source ~/.config/bash/setup.sh" >> ~/.bashrc
