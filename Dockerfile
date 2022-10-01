FROM ubuntu:latest

##########################################################
# Install openssh-server
RUN apt update && apt install openssh-server sudo -y

##########################################################
# Create a group “dmdev”
RUN groupadd dmdev

##########################################################
# Create a user “ivan”
RUN useradd -d /home/ivan -m -s /bin/bash -g dmdev ivan
# Set default password 123 for user ivan
RUN echo "123\n123" | passwd ivan

##########################################################
# Create a user “denis”
RUN useradd -d /home/denis -m -s /bin/bash -g dmdev denis
# Create .ssh directory in denis home directory
RUN mkdir -p /home/denis/.ssh
# Copy the ssh public key in the authorized_keys file.
# The id_rsa.pub below is a public key file you get from ssh-keygen.
# They are under ~/.ssh directory by default.
COPY id_rsa.pub /home/denis/.ssh/authorized_keys
# change ownership of the key file.
RUN chown denis /home/denis/.ssh/authorized_keys && chgrp dmdev /home/denis/.ssh/authorized_keys && chmod 640 /home/denis/.ssh/authorized_keys

##########################################################
# Start SSH service
RUN service ssh start
# Expose docker port 22
EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]