FROM debian:jessie
MAINTAINER Naoaki Obiki
RUN apt-get update && apt-get install -y git supervisor php5
ARG username="git"
RUN groupadd $username && useradd -g $username -d /home/$username $username
RUN mkdir /home/$username
RUN apt-get update && apt-get install -y git-core
ADD settings/git-daemon/.gitconfig /home/$username
ADD settings/supervisor/conf.d/git-daemon.conf /git-daemon.conf.org
RUN chown -R $username:$username /home/$username
RUN echo "mkdir -p /repos/git && chown -R $username:$username /repos/git/" >> /git-daemon.sh
RUN chmod +x /git-daemon.sh
RUN curl -sS "https://getcomposer.org/installer" | php -- --install-dir=/usr/local/bin
RUN mkdir -p /home/$username/.composer && chown $username:$username /home/$username/.composer
RUN composer.phar create-project composer/satis:dev-master --keep-vcs --working-dir=/usr/local/lib/
ADD settings/satis/satis.json /usr/local/lib/satis/
RUN chown -R $username:$username /usr/local/lib/satis/
RUN ln -s /usr/local/lib/satis/bin/satis /usr/local/bin/satis
RUN apt-get install -y nginx
RUN chmod 755 /var/log/nginx/
ADD settings/nginx/nginx.conf /etc/nginx/
RUN systemctl enable nginx
COPY bootstrap.sh /
RUN chmod +x /bootstrap.sh
CMD ["/bootstrap.sh"]
