FROM debian:jessie
MAINTAINER Naoaki Obiki
RUN apt-get update && apt-get install -y git
ARG username="git"
RUN groupadd $username && useradd -g $username -d /home/$username $username
RUN mkdir /home/$username
RUN apt-get update && apt-get install -y git-core supervisor
ADD settings/git-daemon/.gitconfig /home/$username
ADD settings/supervisor/conf.d/git-daemon.conf /git-daemon.conf.org
RUN chown -R $username:$username /home/$username
RUN echo "mkdir -p /repos/git && chown -R $username:$username /repos/git/" >> /git-daemon.sh
RUN chmod +x /git-daemon.sh
RUN apt-get install -y php5 php5-dev php5-cgi php5-cli php5-curl php5-mongo php5-mysql php5-memcache php5-mcrypt mcrypt php5-readline php5-json php5-imagick imagemagick php5-oauth
RUN systemctl disable apache2
RUN curl -sS "https://getcomposer.org/installer" | php -- --install-dir=/usr/local/bin
RUN mkdir -p /home/$username/.composer && chown $username:$username /home/$username/.composer
RUN composer.phar create-project composer/satis:dev-master --keep-vcs --working-dir=/usr/local/lib/
ADD settings/satis/satis.json /usr/local/lib/satis/
RUN chown -R $username:$username /usr/local/lib/satis/
RUN ln -s /usr/local/lib/satis/bin/satis /usr/local/bin/satis
RUN apt-get install -y apache2
RUN a2enmod rewrite ssl proxy status setenvif unique_id
RUN a2dismod userdir
RUN mkdir -p /var/log/apache2/vhost/ && chmod -R 755 /var/log/apache2/
RUN systemctl enable apache2
WORKDIR /var/www/html
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
RUN mkdir -p $APACHE_RUN_DIR $APACHE_LOCK_DIR $APACHE_LOG_DIR
COPY bootstrap.sh /
RUN chmod +x /bootstrap.sh
CMD ["/bootstrap.sh"]
