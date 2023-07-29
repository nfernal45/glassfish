FROM centos:centos8 as build

##########COPY JAVA###############

WORKDIR /java
COPY /dist/*tar.gz .   
RUN tar -xzvf glassfish* && \
    tar -xzvf jdk* && \
    rm -rf *tar.gz

###########INSTALL JAVA AND GLASSFISH################
FROM centos:centos8

RUN cd /etc/yum.repos.d/ && \ 
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
#RUN dnf -y update && 
RUN dnf install -y glibc-langpack-en

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
WORKDIR /java
COPY --from=build /java .
RUN PathToJvm=$(pwd)/$(ls | grep jdk) && ln -s ${PathToJvm} /opt/jdk
RUN PathToGlassfish=$(pwd)/$(ls | grep glassfish*) && ln -s ${PathToGlassfish} /opt/glassfish4
ENV JAVA_HOME=/opt/jdk GF_HOME=/opt/glassfish4
ENV PATH $PATH:${JAVA_HOME}/bin:${GF_HOME}/bin

EXPOSE 4848

#ENV PATH $PATH:${JAVA_HOME}/bin

#ENTRYPOINT java
#CMD [ "--version" ]