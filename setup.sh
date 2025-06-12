#!/bin/bash

set -euo pipefail

export PATH="$HOME/.bin:$PATH:/usr/local/sbin:/usr/sbin:/sbin"

# Check sudo is set up
if ! sudo true; then
  # Set up sudo. It will take full effect only after reboot
  echo 'Please type the password again.'
  su -c "usermod -aG sudo $USER"
  echo 'Sudo utility is successfully configured. To continue, please restart and run the same command again.'
  exit 1
fi
# From now on it is safe to assume sudo is configured

# Keyboard configuration - make Caps Lock do something useful
setxkbmap -option ctrl:nocaps || true  # if we run without X11, no big deal until reboot
sudo sed -i 's/XKBOPTIONS=""/XKBOPTIONS="ctrl:nocaps"/' /etc/default/keyboard

# Install software
# Remove cdrom reference since it can fail apt runs, and we do not have anything useful there anyway.
sudo sed -i 's/^deb cdrom.*$//' /etc/apt/sources.list
# Add GitHub repository so `apt` knows where to pull `gh` utility from
(
  sudo mkdir -p -m 755 /etc/apt/keyrings &&
  out=$(mktemp) &&
  wget -nv "-O$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg &&
  cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null &&
  sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg &&
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
)
# update package version cache and install everything
sudo apt update
sudo apt install -y curl git tmux vim vim-doc vim-gtk3 vim-scripts xclip gh
# Install UV - Python package and project manager. So far it is not yet available via Debian official apt packages (TODO should get there by 2025-10-01)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Install and configure GNOME extensions
gnome-browser-connector gnome-extensions://dash-to-dock%40micxgx.gmail.com?action=install
dconf load /org/gnome/shell/extensions/dash-to-dock/ << EOF
[/]
always-center-icons=false
apply-custom-theme=false
background-color='rgb(0,78,0)'
background-opacity=0.59999999999999998
custom-background-color=true
custom-theme-shrink=true
dash-max-icon-size=48
disable-overview-on-startup=true
dock-fixed=true
dock-position='LEFT'
extend-height=true
height-fraction=0.90000000000000002
icon-size-fixed=false
max-alpha=0.80000000000000004
preferred-monitor=-2
preferred-monitor-by-connector='HDMI-0'
preview-size-scale=0.10000000000000001
transparency-mode='FIXED'
EOF
gnome-browser-connector gnome-extensions://Move_Clock%40rmy.pobox.com?action=install
gnome-browser-connector gnome-extensions://appindicatorsupport%40rgcjonas.gmail.com?action=install

# Setup vim plugins
mkdir -p ~/.vim/colors
# Install ShowMarks plugin to show your vim bookmakrs
(
  cd ~/.vim &&
  curl https://www.vim.org/scripts/download_script.php?src_id=8240 --output showmarks.zip &&
  unzip showmarks.zip;
  rm showmarks.zip
)
# Install desertink color scheme
(
  cd ~/.vim &&
  curl https://www.vim.org/scripts/download_script.php?src_id=20644 --output desertink.tar.gz &&
  tar -xzf desertink.tar.gz &&
  mv desertink/colors/desertink.vim colors;
  rm desertink.tar.gz;
  rm -rf desertink
)

# Download the rest of the repo with config files and ssetup links to those
COMMIT="${1:-main}"
echo "$COMMIT"
DESTINATION="$HOME/.local/debian-setup"
rm -rf $DESTINATION || true
git clone https://github.com/Real-Learning/debian-setup.git $DESTINATION
(cd $DESTINATION && git checkout "$COMMIT" && ./links-setup.sh)

echo -e '\nSetup succeeded! Restart for all the changes to take effect.'
