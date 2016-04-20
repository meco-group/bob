#!/bin/bash
set -e

openssl aes-256-cbc -k "$key" -in id_rsa_bob.enc -out id_rsa_bob -d
chmod 600 id_rsa_bob
