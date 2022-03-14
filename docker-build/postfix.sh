#!/bin/bash
service rsyslog start
sleep 3 
service postfix start
update-ca-certificates
cp /etc/ssl/certs/ca-certificates.crt /var/spool/postfix/etc/ssl/certs/ca-certificates.crt
tail -f /var/log/mail.log

