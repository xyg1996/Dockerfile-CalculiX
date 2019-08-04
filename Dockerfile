FROM ubuntu:bionic
MAINTAINER "Thomas Enzinger <info@thomas-enzinger.de>"

ARG VERSION

# install software
RUN apt-get update                                        \
 && apt-get install -y -f                                 \
      vim ssh sudo wget git                               \
      software-properties-common                          \
      locales bash-completion binutils coreutils          \
      module-init-tools iputils-ping net-tools            \
      libcr-dev mpich mpich-doc                           \
      libgl1-mesa-dev libgl1-mesa-glx                     \
      freeglut3-dev freeglut3 mesa-common-dev             \
      libxmu-dev libxmu-headers libxi-dev                 \
      build-essential cmake libopenmpi-dev openmpi-bin    \
      autoconf autotools-dev                              \
      libncurses-dev libgmp-dev libmpfr-dev libmpc-dev    \
      python python-numpy python-scipy                    \
 && rm -rf /var/lib/apt/lists/*

# config os
RUN useradd --user-group --create-home --shell /bin/bash calculix                           \
 && echo "calculix ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers                                  \
 && update-locale LANG=C.UTF-8 LC_MESSAGES=POSIX                                            \
 && echo 127.0.1.1 $(hostname) >> /etc/hosts                                                \
 && echo "export OMPI_MCA_btl_vader_single_copy_mechanism=none" >> /root/.bashrc            \
 && echo "export OMPI_MCA_btl_vader_single_copy_mechanism=none" >> /home/calculix/.bashrc

SHELL ["/bin/bash", "-c"]

#
COPY "data/cgx_$VERSION.*" /usr/local
COPY scripts/* /opt/
RUN                                                                                         \
 && /opt/install_calculix                                                                   \
 && rm -f /opt/install_calculix /usr/local/*.bz2

# setup run
VOLUME ["/data"]
WORKDIR /data
USER calculix

#
ENTRYPOINT ["/bin/bash", "-ci"]

