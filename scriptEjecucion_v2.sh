#!/bin/bash


cd docker_kafka
docker build -t sllopez/kafka_p1 .
cd ../docker_spark
docker build -t sllopez/spark_p1 .
cd ../docker_server
docker build -t sllopez/server_p1 .
cd ..

docker-compose up
sleep 180
docker exec -it kafka_p1 /opt/kafka_2.12-2.3.0/bin/zookeeper-server-start.sh /opt/kafka_2.12-2.3.0/config/zookeeper.properties
sleep 15
docker exec -it kafka_p1 /opt/kafka_2.12-2.3.0/bin/kafka-server-start.sh /opt/kafka_2.12-2.3.0/config/server.properties
sleep 15 
docker exec -it kafka_p1 /opt/kafka_2.12-2.3.0/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic flight_delay_classification_request
sleep 15 
docker exec -it mongo_p1 mongoimport -d agile_data_science -c origin_dest_distances --file /practica/data/origin_dest_distances.jsonl
#docker exec -it mongo_p1 mongoimport -d agile_data_science -c origin_dest_distances --file /practica_big_data_2019/data/origin_dest_distances.jsonl


sleep 15 
docker exec -it spark_p1 /opt/spark-2.4.7-bin-hadoop2.7/bin/spark-submit --class es.upm.dit.ging.predictor.MakePrediction --packages org.mongodb.spark:mongo-spark-connector_2.11:2.3.2,org.apache.spark:spark-sql-kafka-0-10_2.11:2.4.0 /practica/flight_prediction/target/scala-2.11/flight_prediction_2.11-0.1.jar
#docker exec -it spark_p1 /opt/spark-2.4.7-bin-hadoop2.7/bin/spark-submit --class es.upm.dit.ging.predictor.MakePrediction --packages org.mongodb.spark:mongo-spark-connector_2.11:2.3.2,org.apache.spark:spark-sql-kafka-0-10_2.11:2.4.0 /practica_big_data_2019/flight_prediction/target/scala-2.11/flight_prediction_2.11-0.1.jar


sleep 10
docker exec -it server_p1 python3 /resources/web/predict_flask.py



#docker exec -it spark_p1 /opt/spark-2.4.7-bin-hadoop2.7/bin/spark-submit 
#--class es.upm.dit.ging.predictor.MakePrediction 
#--packages org.mongodb.spark:mongo-spark-connector_2.11:2.3.2,
#org.apache.spark:spark-sql-kafka-0-10_2.11:2.4.0 
#/practica/flight_prediction/target/scala-2.11/flight_prediction_2.11-0.1.jar


# xterm -e "docker-compose up;bash" &

# sleep 180

# xterm -e "docker exec -it kafka /opt/kafka_2.12-2.3.0/bin/zookeeper-server-start.sh /opt/kafka_2.12-2.3.0/config/zookeeper.properties;bash" &
# sleep 15
# xterm -e "docker exec -it kafka /opt/kafka_2.12-2.3.0/bin/kafka-server-start.sh /opt/kafka_2.12-2.3.0/config/server.properties;bash" &
# sleep 15 
# docker exec -it kafka /opt/kafka_2.12-2.3.0/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic flight_delay_classification_request

# docker exec -it mongo mongoimport -d agile_data_science -c origin_dest_distances --file /practica/data/origin_dest_distances.jsonl

# sleep 10

# xterm -e "docker exec -it spark /opt/spark-2.4.4-bin-hadoop2.7/bin/spark-submit --class es.upm.dit.ging.predictor.MakePrediction --packages org.mongodb.spark:mongo-spark-connector_2.11:2.3.2,org.apache.spark:spark-sql-kafka-0-10_2.11:2.4.0 /practica/flight_prediction/target/scala-2.11/flight_prediction_2.11-0.1.jar;bash" &

# sleep 10

# xterm -e "docker exec -it server python3 /resources/web/predict_flask.py;bash" &
