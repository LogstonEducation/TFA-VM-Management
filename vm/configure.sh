# To configure your VM with python3.6, run the following single line of code 
# at the command line (don't copy the "#"):
# curl -fsSL https://raw.githubusercontent.com/logston/py-for-or/master/vm/configure.sh | bash
# Then run these commands to set a password:
# jupyter notebook password
# sudo systemctl restart jupyter
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
        tk8.6-dev \
        git \
        vim \
        less \
        postgresql-9.6 \
        postgresql-client-9.6

# Install Python
PY_VERSION=$(python -V)
if [ "$PY_VERSION" != "Python 3.6.3" ]; then
echo "Installing Python 3.6.3"
cd /tmp
wget https://www.python.org/ftp/python/3.6.3/Python-3.6.3.tgz -O python.tgz
tar -xvzf python.tgz
cd Python-3.6.3
./configure --prefix=/usr/local
make -j 4
sudo make install
sudo ln -s /usr/local/bin/python3.6 /usr/local/bin/python
sudo ln -s /usr/local/bin/pip3 /usr/local/bin/pip
sudo chown -R $(whoami):$(whoami) /usr/local/
cd ~
fi

echo "Configuring Jupyter"

pip install -r https://raw.githubusercontent.com/logston/py-for-or/master/vm/requirements.txt

mkdir -p .jupyter/

cat << 'EOF' > .jupyter/jupyter_notebook_config.py
## Whether to allow the user to run the notebook as root.
c.NotebookApp.allow_root = True
## The IP address the notebook server will listen on.
c.NotebookApp.ip = '0.0.0.0'
## The port the notebook server will listen on.
c.NotebookApp.port = 80
## Whether to open in a browser after starting. The specific browser used is
#  platform dependent and determined by the python standard library `webbrowser`
#  module, unless it is overridden using the --browser (NotebookApp.browser)
#  configuration option.
c.NotebookApp.open_browser = False
EOF

jupyter contrib nbextension install --sys-prefix

cat <<-EOF | sudo tee /etc/systemd/system/jupyter.service 
[Unit]
Description=JupyterNotebook
[Service]
WorkingDirectory=/home/$USER
ExecStart=/usr/local/bin/jupyter notebook --config=/home/$USER/.jupyter/jupyter_notebook_config.py
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable jupyter.service
sudo systemctl start jupyter.service

echo "Configuring Postgres"

sudo -H -u postgres bash -c "psql -c \"CREATE ROLE $USER CREATEDB LOGIN ENCRYPTED PASSWORD 'supersecret';\""
psql -d postgres -c "CREATE DATABASE $USER;"

curl https://raw.githubusercontent.com/logston/py-for-or/master/data/imdb.sh | bash
curl https://raw.githubusercontent.com/logston/py-for-or/master/data/bank.sh | bash

echo "Configuration Complete"
