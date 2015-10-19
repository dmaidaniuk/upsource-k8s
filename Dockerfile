FROM ubuntu:15.10
ENV UPSOURCE_VERSION 2.0.3682

EXPOSE 8080

RUN apt-get update && apt-get install -y wget unzip openjdk-8-jdk
WORKDIR /opt
RUN wget -q https://download.jetbrains.com/upsource/upsource-${UPSOURCE_VERSION}.zip
ADD upsource-${UPSOURCE_VERSION}.zip.sha256 ./
RUN sha256sum -c upsource-${UPSOURCE_VERSION}.zip.sha256 && unzip upsource-${UPSOURCE_VERSION}.zip
ADD limits.conf /etc/security/
ADD startup.sh /opt/
ENTRYPOINT ["/opt/startup.sh"]
