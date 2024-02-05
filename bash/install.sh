#!/usr/bin/bash

mkdir -p ~/.config/bash
cp -r * ~/.config/bash
sudo cp -r ./packages/bin/* /usr/local/bin

# Set hostname (default $(whoami)
echo "Please input your hostname: "
read hostname
echo "Hello ${hostname}"
echo "HOST=['${hostname}']" >> ~/.config/bash/variables/host_name.sh

echo "source ~/.config/bash/setup.sh" >> ~/.bashrc

bash
