FROM ubuntu:bionic
MAINTAINER "Thomas Enzinger <info@thomas-enzinger.de>"

ARG VERSION
ARG SOURCE_BRANCH
ARG BUILD_DATE
ARG SOURCE_COMMIT
ARG DOCKERFILE_PATH
ARG SOURCE_TYPE

# install software
RUN apt-get update                                        \
 && apt-get upgrade -y                                    \
 && apt-get install -y                                    \
      vim ssh sudo wget git                               \
      software-properties-common                          \
      locales bash-completion binutils coreutils          \
      module-init-tools iputils-ping net-tools            \
      libcr-dev mpich mpich-doc                           \
      libgl1-mesa-dev libgl1-mesa-glx                     \
      freeglut3-dev freeglut3 mesa-common-dev             \
      libxmu-dev libxmu-headers libxi-dev

# config os
RUN useradd --user-group --create-home --shell /bin/bash calculix   \
 && echo "calculix ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers          \
 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX                    \
 && echo 127.0.1.1 $(hostname) >> /etc/hosts

# OpenFoam Requirements
RUN apt-get install -y                                                                   \
      build-essential cmake libopenmpi-dev openmpi-bin autoconf autotools-dev            \
      libncurses-dev libgmp-dev libmpfr-dev libmpc-dev                                   \
      python python-numpy python-scipy

#
COPY "data/cgx_$VERSION.bz2" /opt/
COPY "data/cgx_$VERSION.all.tar.bz2" /opt/
COPY scripts/install_calculix /opt/
RUN /opt/install_calculix && rm -f /opt/install_calculix

# clean up
RUN apt-get autoremove && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# setup run
VOLUME ["/data"]
WORKDIR /data
USER calculix
SHELL ["/bin/bash"]

COPY scripts/entrypoint.sh /opt/
ENTRYPOINT ["/opt/entrypoint.sh"]
CMD []


