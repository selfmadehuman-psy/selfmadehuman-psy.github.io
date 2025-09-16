FROM ubuntu:noble

# make RUN commands use bash instad of sh 
RUN rm /bin/sh && ln -s /bin/bash /bin/sh 

# Set up user
ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=1000

# Create a non-root user
RUN useradd -s /bin/bash -m $USERNAME \
  # Add sudo support for the non-root user
  && apt-get update \
  && apt-get install -y sudo \
  && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
  && chmod 0440 /etc/sudoers.d/$USERNAME \
  && rm -rf /var/lib/apt/lists/*

# Use default bashrc for user
RUN cp /etc/skel/.bashrc /home/$USERNAME

# # Give new user rights to its own home dir
# RUN chown $USER_UID:$USER_GID /home/$USERNAME

USER user

# Install prerequisites to jekyll
RUN sudo apt-get update && sudo apt-get install -y \
    ruby-full build-essential zlib1g-dev git

ENV GEM_HOME="/home/$USERNAME/gems"
ENV PATH="$GEM_HOME/bin:$PATH"

RUN echo '# Install Ruby Gems to ~/gems' >> ~/.bashrc && \
    echo 'export GEM_HOME="$HOME/gems"' >> ~/.bashrc && \
    echo 'export PATH="$HOME/gems/bin:$PATH"' >> ~/.bashrc

# install jekyll
RUN gem install jekyll bundler

