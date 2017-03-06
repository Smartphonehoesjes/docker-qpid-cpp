FROM ubuntu:xenial

RUN apt-get update -y
RUN apt-get install -y wget

RUN apt-get install -y build-essential python ruby
RUN apt-get install -y cmake libblkid-dev e2fslibs-dev libboost-all-dev libaudit-dev

RUN mkdir -p qpid-cpp/bld

#download and build qpid-proton
RUN cd qpid-cpp/bld && wget http://apache.40b.nl/qpid/proton/0.17.0/qpid-proton-0.17.0.tar.gz && tar -zxf qpid-proton-0.17.0.tar.gz
RUN cd qpid-cpp/bld/qpid-proton-0.17.0 && cmake . -DCMAKE_INSTALL_PREFIX=/usr -DSYSINSTALL_BINDINGS=ON
RUN cd qpid-cpp/bld/qpid-proton-0.17.0 && make all && make install

#download qpid
RUN cd qpid-cpp/bld && wget http://apache.proserve.nl/qpid/cpp/1.36.0/qpid-cpp-1.36.0.tar.gz && tar -xzf qpid-cpp-1.36.0.tar.gz && cd qpid-cpp-1.36.0
RUN cd qpid-cpp/bld/qpid-cpp-1.36.0 && cmake .
RUN cd qpid-cpp/bld/qpid-cpp-1.36.0 && make all && make install

#clean
RUN apt-get purge -y wget

ENTRYPOINT ["/usr/local/sbin/qpidd", "--protocols=amqp1.0"]
