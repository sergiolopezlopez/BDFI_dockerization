# spark_docker
# Spark 2.4.0

FROM openjdk:8-jdk

# Update apt-get and install dnsutils
RUN apt-get update
RUN apt-get install -y wget supervisor dnsutils 
RUN rm -rf /var/lib/apt/lists/* 
RUN apt-get clean 

# Install spark 2.4.0
RUN wget -q https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-hadoop2.7.tgz -O /tmp/spark.tgz && \tar xfz /tmp/spark.tgz -C /opt 

CMD ["supervisord", "-n"]
