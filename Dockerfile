FROM debian:jessie
MAINTAINER Naoaki Obiki
RUN apt-get update && apt-get install -y git
ARG gituser="git"
RUN groupadd $gituser && useradd -g $gituser -d /home/$gituser $gituser
RUN mkdir /home/$gituser
RUN apt-get update && apt-get install -y git-core
ADD settings/git-daemon/.gitconfig /home/$gituser
RUN chown -R $gituser:$gituser /home/$gituser
RUN echo "mkdir -p /repos/git && chown -R $gituser:$gituser /repos/git/" >> /git-daemon.sh
RUN echo "git daemon --reuseaddr --export-all --enable=receive-pack --base-path=/repos/git/ --user=git --listen=0.0.0.0 --port=9418 /repos/git/" >> /git-daemon.sh
RUN chmod +x /git-daemon.sh
COPY bootstrap.sh /
RUN chmod +x /bootstrap.sh
CMD ["/bootstrap.sh"]
