#!/bin/bash
set -e

VERSION="3.0.0-beta.6"

if [ -n "`$SHELL -c 'echo $ZSH_VERSION'`" ]; then
  shell_profile="zshrc"
elif [ -n "`$SHELL -c 'echo $BASH_VERSION'`" ]; then
  shell_profile="bashrc"
fi

unameOut="$(uname -s)"
case "${unameOut}" in
  Linux*)     machine=Linux;;
  Darwin*)    machine=macOS;;
  *)          machine="UNKNOWN:${unameOut}"
esac

if [ "${machine}" == "macOS" ]; then
  DFILE="moul-darwin"
elif [ "${machine}" == "Linux" ]; then
  DFILE="moul-linux"
else
  echo "Please specific OS"
  exit 1
fi

if [ -d "$HOME/.local/bin" ]; then
  echo "The '.local/bin' directory already exist. Using it."
else
  echo "The '.local/bin' directory not exist. Creating it."
  mkdir "$HOME/.local/bin"
fi

echo "Downloading $DFILE ..."
curl -LJO https://github.com/moulco/moul/releases/download/$VERSION/$DFILE.tar.gz

if [ $? -ne 0 ]; then
  echo "Download failed! Exiting."
  exit 1
fi

echo "Extracting File..."
tar -xzf $DFILE.tar.gz -C "$HOME"
mv "$HOME/$DFILE" "$HOME/.local/bin/moul"

echo "Updating environment variables"
touch "$HOME/.${shell_profile}"

echo 'export PATH=$PATH:~/.local/bin' >> "$HOME/.${shell_profile}"

echo -e "\nmoul version $VERSION was installed.\n\nMake sure to relogin into your shell or run:"
echo -e "$ source $HOME/.${shell_profile}\nto update your environment variables.\n"
echo "Or, opening a new terminal window usually just works."
rm -f $DFILE.tar.gz
