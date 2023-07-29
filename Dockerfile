FROM centos:centos8 as build

##########COPY JAVA###############
RUN 
RUN cd /etc/yum.repos.d/ && \   
    sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* && \
    sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN dnf install unzip -y
WORKDIR /java
COPY /dist/*tar.gz .
COPY /dist/*.zip .
RUN unzip *.zip && \   
    tar -xzvf *tar.gz | grep jdk && \ 
    rm -rf *tar.gz *.zip

###########INSTALL JAVA AND GLASSFISH################
FROM centos:centos8
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