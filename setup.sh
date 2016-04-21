#!/bin/bash
set -e

openssl aes-256-cbc -k "$key" -in id_rsa_bob.enc -out $HOME/id_rsa_bob -d
chmod 600 $HOME/id_rsa_bob

openssl aes-256-cbc -k "$key" -in setup_enc.sh.enc -out setup_enc.sh -d
chmod 700 setup_enc.sh

source setup_enc.sh

ssh-keyscan github.com >> ~/.ssh/known_hosts
ssh-keyscan $GATE >> ~/.ssh/known_hosts

bob_get() {
  scp -i $HOME/id_rsa_bob $USER@$GATE:~/repo/$1 .
}

bob_put() {
  scp -i $HOME/id_rsa_bob $1 $USER@$GATE:~/repo/
}

bob_putdir() {
  scp -i $HOME/id_rsa_bob -r $1 $USER@$GATE:~/repo/$2
}
