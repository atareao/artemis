FROM debian:bullseye-slim

RUN apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends \
                    --yes \
                    openjdk-11-jre \
                    libaio \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
