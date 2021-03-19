echo "Installing $1"

if [ -x "$(which $1)" ]
  then
    echo "$1 is already installed."
    exit
fi

sudo apt-get install $1 -y

if [ -a $1_after_install.sh ]
  then
    ./$1_after_install.sh
fi
