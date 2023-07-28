FROM alpine:3.18.2 as build

##########COPY JAVA###############
RUN apk --no-progress --purge --no-cache upgrade
WORKDIR /java
COPY /dist/*tar.gz .
COPY /dist/*.zip .
RUN unzip *.zip
RUN tar -xzvf *tar.gz | grep jdk && rm -rf *tar.gz *.zip

###########INSTALL JAVA AND GLASSFISH################
FROM alpine:3.18.2
WORKDIR /java
COPY /dist/*.apk .
COPY --from=build /java .
RUN apk add --force-overwrite --allow-untrusted *.apk
RUN PathToJvm=$(pwd)/$(ls | grep jdk) && ln -s ${PathToJvm} /opt/jdk
RUN PathToGlassfish=$(pwd)/$(ls | grep glassfish*) && ln -s ${PathToGlassfish} /opt/glassfish4
ENV JAVA_HOME=/opt/jdk GF_HOME=/opt/glassfish4
ENV PATH $PATH:${JAVA_HOME}/bin:${GF_HOME}/bin

EXPOSE 4848

#ENV PATH $PATH:${JAVA_HOME}/bin

#ENTRYPOINT java
#CMD [ "--version" ]