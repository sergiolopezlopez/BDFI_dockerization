# Dockerization_BDFI

# Despliegue en local
En esta sección se va a indicar como desplegar el código en local. El código se puede encontrar en el siguiente enlace: https://github.com/ging/practica_big_data_2019
## Versiones utilizadas
Las versiones utilizadas para la ejecución en local son:
Kafka 2.12-2.3.0
Spark 2.4.0
Mongo 4.4.1
Python 3.7.4

Aunque no son las más actuales, se han empleado estas ya que para la predicción de vuelos, se ha empleado Spark-submit en vez de Intellij.

## Descarga de datos
El fichero JSON con las distancias se obtiene con el siguiente comando:

```
resources/download_data.sh
```

Los ficheros generados se instalan en la carpeta /data.

## Instalación de dependencias
Las librerías requeridas se instalan ejecutando el siguiente comando desde la carpeta raíz:

```
pip install -r requirements.txt
```

## Kafka y Zookeeper
Para ejecutar Zookeeper y Kafka, nos ubicamos en la carpeta de Kafka descargada y ejecutamos los siguientes comandos:

```
bin/zookeeper-server-start.sh config/zookeeper.properties

bin/kafka-server-start.sh config/server.properties

bin/kafka-topics.sh \
        --create \
        --zookeeper localhost:2181 \
        --replication-factor 1 \
        --partitions 1 \
        --topic flight_delay_classification_request

```

El primero inicia Zookeeper, el segundo inicia Kafka, y el tercero crea el topic de Kafka. Al tercer comando nos debería responder con:

```
Created topic flight_delay_classification_request
```