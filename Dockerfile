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

RUN apk add --force-overwrite --allow-untrusted *.apk && rm -rf *.apk
RUN pathtojvm=$(pwd)/$(ls | grep jdk) && ln -s ${pathtojvm} /opt/jdk
ENV JAVA_HOME=/opt/jdk
ENV PATH $PATH:${JAVA_HOME}/bin

#ENTRYPOINT java
#CMD [ "--version" ]