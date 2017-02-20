FROM debian:jessie
MAINTAINER Naoaki Obiki
RUN apt-get update && apt-get install -y git
ARG username="git"
RUN groupadd $username && useradd -g $username -d /home/$username $username
RUN mkdir /home/$username
RUN apt-get update && apt-get install -y git-core
ADD settings/git-daemon/.gitconfig /home/$username
RUN chown -R $username:$username /home/$username
RUN echo "mkdir -p /repos/git && chown -R $username:$username /repos/git/" >> /git-daemon.sh
RUN echo "git daemon --reuseaddr --export-all --enable=receive-pack --base-path=/repos/git/ --user=git --listen=0.0.0.0 --port=9418 /repos/git/" >> /git-daemon.sh
RUN chmod +x /git-daemon.sh
COPY bootstrap.sh /
RUN chmod +x /bootstrap.sh
CMD ["/bootstrap.sh"]
