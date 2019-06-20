#!/bin/bash
set -e

openssl aes-256-cbc -k "$key" -in id_rsa_bob.enc -out $HOME/id_rsa_bob -d
chmod 600 $HOME/id_rsa_bob

openssl aes-256-cbc -k "$key" -in setup_enc.sh.enc -out setup_enc.sh -d
chmod 700 setup_enc.sh

source setup_enc.sh

#sudo dpkg -i https://admin.kuleuven.be/icts/services/extranet/ps-pulse-linux-9-0r3-0-b923-ubuntu-debian-64-bit.deb
#/usr/local/pulse/pulsesvc -L5 -h extranet.kuleuven.be -u $USER -U https://extranet.kuleuven.be/b -r b-realm -p $PROXY_PASSWORD &

sudo apt-get install davfs2

echo "mounting"
echo "https://drives.kuleuven.be/hcwebdav/ $USER $DRIVE_PASSWORD" > secrets
sudo bash -c "cat secrets >> /etc/davfs2/secrets"

sudo mkdir -p /mnt/dav
sudo mount -t davfs -o ro https://drives.kuleuven.be/hcwebdav/ /mnt/dav/ &
ls /mnt/dav

ssh-keyscan github.com >> ~/.ssh/known_hosts
ssh-keyscan $GATE >> ~/.ssh/known_hosts

bob_get() {
  scp -i $HOME/id_rsa_bob $USER@$GATE:~/repo/$1 .
}

bob_put() {
  ssh -i $HOME/id_rsa_bob $USER@$GATE "mkdir -p ~/repo/"
  scp -i $HOME/id_rsa_bob $1 $USER@$GATE:~/repo/
  
  #ssh -i $HOME/id_rsa_bob $REPO_USER@$GATE "mkdir -p ~/repo/"
  #scp -i $HOME/id_rsa_bob $1 $REPO_USER@$GATE:~/repo/
  
}

bob_putdir() {
  ssh -i $HOME/id_rsa_bob $USER@$GATE "mkdir -p ~/repo/$2"
  scp -i $HOME/id_rsa_bob -r $1/* $USER@$GATE:~/repo/$2

  #ssh -i $HOME/id_rsa_bob $REPO_USER@$GATE "mkdir -p ~/repo/$2"
  #scp -i $HOME/id_rsa_bob -r $1/* $REPO_USER@$GATE:~/repo/$2
}
