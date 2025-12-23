#!/bin/bash

HOME=/home/ubuntu

sudo apt-get update -y
sudo apt-get install -y msmtp msmtp-mta ca-certificates bsd-mailx mutt

mkdir -p ~/.msmtp
chmod 700 ~/.msmtp

cat <<EOF > ~/.msmtprc
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account        gmail
host           smtp.gmail.com
port           587
from           prajwalxr@gmail.com
user           prajwalxr@gmail.com
passwordeval   "cat ~/.gmail_app_password"

account default : gmail
EOF

chmod 600 ~/.msmtprc

echo "msmtp + mutt setup completed successfully."

