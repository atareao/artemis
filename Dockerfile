FROM debian:bullseye-slim

ARG VERSION=2.31.0

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends \
                    --yes \
                    wget \
                    openjdk-11-jre \
                    libaio1 \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

#ADD https://www.apache.org/dyn/closer.cgi?filename=activemq/activemq-artemis/2.31.0/apache-artemis-2.31.0-bin.tar.gz&action=download /app/apache-artemis.tar.gz
RUN mkdir /app && \
    wget "https://www.apache.org/dyn/closer.cgi?filename=activemq/activemq-artemis/${VERSION}/apache-artemis-${VERSION}-bin.tar.gz&action=download" -O /app/artemis.tar.gz && \
    tar xvzf /app/artemis.tar.gz -C /app && \
    rm -rf /app/artemis.tar.gz && \
    mv "/app/apache-artemis-${VERSION}" /app/artemis

RUN /app/artemis/bin/artemis create --user artemis \
                                    --password artemis \
                                    --allow-anonymous \
                                    /app/instance
RUN sed -i 's,<binding name="artemis" uri="http://localhost:8161">,<binding name="artemis" uri="http://0.0.0.0:8161">,g' /app/instance/etc/bootstrap.xml
RUN sed -i 's,<allow-origin>*://localhost*</allow-origin>,<allow-origin>*://*</allow-origin>,g' /app/instance/etc/jolokia-access.xml

RUN groupadd -g 1000 -r artemis && \
    useradd -r -u 1000 -g artemis artemis && \
    chown -R artemis:artemis /app/instance

EXPOSE  8161 \
        61616

USER artemis
WORKDIR /app/instance

CMD ["/app/instance/bin/artemis", "run"]
