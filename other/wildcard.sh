#!/bin/sh

# generate woldcard self signed certificate

openssl genrsa 2048 > wildcard.keyout
openssl req -new -x509 -nodes -sha1 -days 3650 -key wildcard.key > wildcard.cert
openssl x509 -noout -fingerprint -text < wildcard.cert > wildcard.info
cat wildcard.cert wildcard.key > wildcard.pem
chmod 644 wildcard.key wildcard.pem
