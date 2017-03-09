FROM ubuntu:xenial

RUN apt-get update -y && \
    apt-get install -y wget \
                       build-essential \
                       python \
                       ruby \
                       cmake \
                       libblkid-dev \
                       e2fslibs-dev \
                       libboost-all-dev \
                       libaudit-dev

RUN mkdir -p qpid-cpp/bld

#download, build and install qpid-proton
RUN cd qpid-cpp/bld && \
    wget http://apache.40b.nl/qpid/proton/0.17.0/qpid-proton-0.17.0.tar.gz && \
    tar -zxf qpid-proton-0.17.0.tar.gz && \
    cd qpid-proton-0.17.0 && \
    cmake . -DCMAKE_INSTALL_PREFIX=/usr -DSYSINSTALL_BINDINGS=ON && \
    make all && \
    make install && \
    make clean && \
    rm -r /usr/share/proton-0.17.0

#download, build and install qpid
RUN cd qpid-cpp/bld && \
    wget http://apache.proserve.nl/qpid/cpp/1.36.0/qpid-cpp-1.36.0.tar.gz && \
    tar -xzf qpid-cpp-1.36.0.tar.gz && \
    cd qpid-cpp-1.36.0 && \
    cmake . && \
    make all && \
    make install && \
    make clean && \
    rm -r /usr/local/share/qpid

#clean
RUN apt-get purge -y wget && \
    apt-get -y clean all

ENTRYPOINT ["/usr/local/sbin/qpidd", "--protocols=amqp1.0"]
