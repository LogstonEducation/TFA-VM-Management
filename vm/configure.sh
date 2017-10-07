# curl -fsSL https://raw.githubusercontent.com/logston/py-for-or/master/vm/configure.sh | bash
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get install -y \
        build-essential \
        libffi-dev \
        python-dev \
        sqlite3 \
        libsqlite3-dev \
        libreadline-dev \
        openssl \
        libssl-dev \
        liblzma-dev \
        libbz2-dev \
        zlib1g-dev \
        libncurses5-dev \
        libgdbm-dev \
        tcl8.6-dev \
        tk8.6-dev
cd /tmp
wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz -O python.tgz
tar -xvzf python.tgz
cd Python-3.6.3
./configure --prefix=/usr/local
make -j 4
sudo make install
echo "alias python=/usr/local/bin/python3" > ~/.bash_aliases
source ~/.bashrc
