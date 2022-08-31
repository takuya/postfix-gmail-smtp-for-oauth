FROM ubuntu:20.04
ENV DEBCONF_NOWARNINGS=yes
RUN echo "Apt Config" && \
echo "APT::Install-Suggests 0;\nAPT::Install-Recommends 0;" | tee /etc/apt/apt.conf.d/00-no-install-recommends && \
echo "path-exclude=/usr/share/locale/*\npath-exclude=/usr/share/man/*\npath-exclude=/usr/share/doc/*\n" | tee  /etc/dpkg/dpkg.cfg.d/01-nodoc && \
apt-get update && \
apt-get upgrade -y 

RUN apt-get install -y software-properties-common &&\
  add-apt-repository -y ppa:sasl-xoauth2/stable && \
  apt-get install -y rsyslog postfix sasl-xoauth2 sasl2-bin &&\
  saslpluginviewer
RUN sed -i '/imklog/s/^/#/' /etc/rsyslog.conf

COPY etc/sasl-xoauth2.conf /etc/sasl-xoauth2.conf
COPY etc/tokens/sender.tokens.json /var/spool/postfix/etc/tokens/sender.tokens.json
COPY etc/postfix/main.cf /etc/postfix/main.cf
COPY etc/postfix/sasl_passwd /etc/postfix/sasl_passwd
RUN echo "Postfix prepare -- start." && \
postmap /etc/postfix/sasl_passwd && \
update-ca-certificates && \
mkdir -p /var/spool/postfix/etc/ssl/certs &&\
cp /etc/ssl/certs/ca-certificates.crt /var/spool/postfix/etc/ssl/certs/ && \
chown -R postfix:postfix /var/spool/postfix/etc/tokens/ && \
echo "Postfix prepare -- done"

COPY postfix.sh /opt/postfix.sh
RUN chmod +x /opt/postfix.sh
ENV TZ Asia/Tokyo
EXPOSE 25/tcp
CMD /opt/postfix.sh
