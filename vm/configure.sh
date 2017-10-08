# To configure your VM with python3.6, run the following single line of code 
# at the command line (don't copy the "#"):
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
        tk8.6-dev \
        git
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

pip install jupyter

jupyter notebook --generate-config

sudo cat << 'EOF' > /etc/systemd/system/jupyter.service
[Unit]
Description=JupyterNotebook
[Service]
WorkingDirectory=${HOME}
ExecStart=/usr/local/bin/jupyter notebook --config=${HOME}/.jupyter/jupyter_notebook_config.py
[Install]
WantedBy=multi-user.target
EOF

sudo systemctl enable jupyter.service
sudo systemctl start jupyter.service
