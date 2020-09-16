FROM ubuntu:20.04
RUN apt-get update && apt-get install -y openssh-server sudo telnet
RUN mkdir /var/run/sshd
RUN apt-get update && apt-get install curl vim software-properties-common iputils-ping -y
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
chmod +x ./kubectl && \
mv ./kubectl /usr/local/bin/kubectl
COPY getstate.js /opt/
COPY start.sh /opt/
RUN chmod +x /opt/start.sh
ARG USER=ubuntu
ARG UID=1000
ARG GID=1000
# default password for user
ARG PW=ubuntu123
RUN useradd -m ${USER} --uid=${UID} && echo "${USER}:${PW}" | \
      chpasswd
RUN echo 'ubuntu ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
SHELL ["/bin/bash", "-c"]
RUN mkdir -p /opt/mongo-port-forward
WORKDIR /opt/mongo-port-forward
EXPOSE 22 27017
CMD bash /opt/start.sh
