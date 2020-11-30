# kafka_docker
# Kafka and Zookeeper

FROM openjdk:8-jdk

ENV ZOOKEEPER_VERSION 3.6.2
ENV SCALA_VERSION 2.12
ENV KAFKA_VERSION 2.3.0

ENV ZOOKEEPER_HOME /opt/zookeeper-"$ZOOKEEPER_VERSION"
ENV KAFKA_HOME /opt/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION"

# Get Zookeeper and unzip
RUN wget http://apache.org/dist/zookeeper/zookeeper-"$ZOOKEEPER_VERSION"/apache-zookeeper-"$ZOOKEEPER_VERSION"-bin.tar.gz -O /tmp/zookeeper-"$ZOOKEEPER_VERSION".tgz

# Install Zookeeper and update apt-get
RUN apt-get update
RUN apt-get install -y zookeeper wget supervisor dnsutils 
RUN rm -rf /var/lib/apt/lists/* 
RUN apt-get clean 

#Install Kafka
RUN wget -q http://apache.uvigo.es/kafka/"$KAFKA_VERSION"/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -O /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz && \
    tar xfz /tmp/kafka_"$SCALA_VERSION"-"$KAFKA_VERSION".tgz -C /opt 


# Port 2181: zookeeper
# Port 9092: kafka
EXPOSE 2181 9092

CMD ["supervisord", "-n"]
CMD ["supervisord", "-n"]

