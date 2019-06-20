#!/bin/bash
set -e

openssl aes-256-cbc -k "$key" -in id_rsa_bob.enc -out $HOME/id_rsa_bob -d
chmod 600 $HOME/id_rsa_bob

openssl aes-256-cbc -k "$key" -in setup_enc.sh.enc -out setup_enc.sh -d
chmod 700 setup_enc.sh

source setup_enc.sh

#sudo dpkg -i https://admin.kuleuven.be/icts/services/extranet/ps-pulse-linux-9-0r3-0-b923-ubuntu-debian-64-bit.deb
#/usr/local/pulse/pulsesvc -L5 -h extranet.kuleuven.be -u $USER -U https://extranet.kuleuven.be/b -r b-realm -p $DRIVE_PASSWORD &

sudo apt-get install davfs2

echo "mounting"
echo "https://drives.kuleuven.be/hcwebdav/ $USER $DRIVE_PASSWORD" > secrets
sudo bash -c "cat secrets >> /etc/davfs2/secrets"

sudo mkdir -p /mnt/dav

#(while true ; do sleep 60 ; echo "ping" ; done ) &
#ssh-keyscan serveo.net >> ~/.ssh/known_hosts
#echo -e "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDNPkKyOfNMobbgIqD0WvkBTzhEs6St8GYC7aYPT4C0eMimuUBJoQbuUeZQS3hkk9RcdG6h8z0Da70mMV82rcWgztE0obdULduOqDV0GrL6TiqaxoHGTEHPzkq7G48B48S+kmQba0rqURtMJ6SLdr/jElJhnVFC2SC8cYz4Q5BikcuX16LNhxLTxcWSq9Ug9cGO/Gc65n2tKUqPy9Ky4LEURBF3zmUftUdR7wE0GUahsti1aDAQGNbB2ccrpUZWQkVxTzol4ABaCEDo1wBPuug4CBuy+kaIj2aDi01z5D52ED2jsa+g38PStV8zJFFrJJMY10RwigMhHVoOfd7bMF3H jgillis@jglab-work" >> ~/.ssh/authorized_keys
#whoami
#export -p > $HOME/env.txt
#ssh -R casadidebug:22:localhost:22 serveo.net

sudo mount -t davfs -o ro https://drives.kuleuven.be/hcwebdav/ /mnt/dav/
ls /mnt/dav

export BOB=/mnt/dav/Shared/SET-PMA-MECO-ME0038/Research-0002/software/bob
ls $BOB

ssh-keyscan github.com >> ~/.ssh/known_hosts
ssh-keyscan $GATE >> ~/.ssh/known_hosts

bob_get() {
  cp -R $BOB/$1 .
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
