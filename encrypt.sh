openssl aes-256-cbc -k $1 -in id_rsa_bob -out id_rsa_bob.enc
openssl aes-256-cbc -k $1 -in id_rsa_bob.pub -out id_rsa_bob.pub.enc
openssl aes-256-cbc -k $1 -in setup_enc.sh -out setup_enc.sh.enc
