#!/bin/bash

cd kafka_docker
docker build -t sllopez/kafka_p1 .

cd ../server_docker
docker build -t sllopez/server_p1 .

cd ../spark_docker
docker build -t sllopez/spark_p1 .

cd ..
docker-compose up

