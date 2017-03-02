FROM ubuntu:xenial
MAINTAINER 030

RUN apt-get update -y
RUN apt-get install -y git
RUN git clone https://github.com/apache/qpid-cpp.git
RUN mkdir qpid-cpp/bld
RUN apt-get install -y build-essential python ruby
RUN apt-get install -y cmake libblkid-dev e2fslibs-dev libboost-all-dev libaudit-dev
RUN cd qpid-cpp/bld && cmake ..
RUN cd qpid-cpp/bld && make all && make install

ENTRYPOINT ["/usr/local/sbin/qpidd"]
