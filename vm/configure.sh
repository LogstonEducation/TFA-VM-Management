# To configure your VM with python3, run the following single line of code 
# at the command line from the VM (don't copy the "#" or the "$"):
#     $ curl -fsSL https://bitbucket.org/LogstonEducation/tfa-vm-management/raw/master/vm/configure.sh | bash
sudo apt-get update
sudo apt-get install -y \
        build-essential \
        bash-completion \
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
        tk8.6-dev \
        git \
        vim \
        less
        
git config --global core.editor "vim"

# Install Python
PY_VERSION=$(python3 -V)
if [ "$PY_VERSION" != "Python 3.8.1" ]; then
echo "Installing Python"
cd /tmp
wget https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tgz -O python.tgz
tar -xvzf python.tgz
cd Python-3.8.1
./configure --prefix=/usr/local
make -j 4
sudo make install
sudo ln -s /usr/local/bin/python3.8 /usr/local/bin/python
sudo ln -s /usr/local/bin/pip3 /usr/local/bin/pip
sudo chown -R $(whoami):$(whoami) /usr/local/
cd ~
fi

echo "Installing Postgres"

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
sudo apt-get update
sudo apt-get install -y \
        postgresql-12 \
        postgresql-client-12

echo "Configuring Postgres"

sudo -H -u postgres bash -c "psql -c \"CREATE ROLE $USER CREATEDB LOGIN ENCRYPTED PASSWORD 'supersecret';\""
psql -d postgres -c "CREATE DATABASE $USER;"

curl https://bitbucket.org/LogstonEducation/tfa-vm-management/raw/master/data/imdb.sh | bash
curl https://bitbucket.org/LogstonEducation/tfa-vm-management/raw/master/data/bank.sh | bash

echo "Configuration Complete"
