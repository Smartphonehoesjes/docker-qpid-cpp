FROM ubuntu:xenial

#DOCKER prefix was added to prevent that native qpid env variables will be overwritten
ENV DOCKER_PROTON_VERSION 0.17.0
ENV DOCKER_QPID_VERSION 1.36.0

RUN apt-get update -y && \
    apt-get install -y wget \
                       build-essential \
                       python \
                       ruby \
                       cmake \
                       libblkid-dev \
                       e2fslibs-dev \
                       libboost-all-dev \
                       libaudit-dev && \
    mkdir -p qpid-cpp/bld && \
    cd qpid-cpp/bld && \
    wget http://apache.40b.nl/qpid/proton/${DOCKER_PROTON_VERSION}/qpid-proton-${DOCKER_PROTON_VERSION}.tar.gz && \
    tar -zxf qpid-proton-${DOCKER_PROTON_VERSION}.tar.gz && \
    cd qpid-proton-${DOCKER_PROTON_VERSION} && \
    cmake . -DCMAKE_INSTALL_PREFIX=/usr -DSYSINSTALL_BINDINGS=ON && \
    make all && \
    make install && \
    make clean && \
    rm -r /usr/share/proton-${DOCKER_PROTON_VERSION} && \
    wget http://apache.proserve.nl/qpid/cpp/${DOCKER_QPID_VERSION}/qpid-cpp-${DOCKER_QPID_VERSION}.tar.gz && \
    tar -xzf qpid-cpp-${DOCKER_QPID_VERSION}.tar.gz && \
    cd qpid-cpp-${DOCKER_QPID_VERSION} && \
    cmake . && \
    make all && \
    make install && \
    make clean && \
    rm -r /usr/local/share/qpid && \
    apt-get --purge autoremove -y wget \
                                  build-essential \
                                  cmake \
                                  libblkid-dev \
                                  e2fslibs-dev \
                                  libaudit-dev && \
                                  #removing python, ruby or libboost-all-dev will remove libboost that is required to run qpid
    apt-get -y clean all

CMD ["/usr/local/sbin/qpidd", "--protocols=amqp1.0"]
