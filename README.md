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

## MongoDB
En el comando de este paso se va a emplear el fichero JSON descargado en el primer paso, por lo que es importante que ese haya funcionado correctamente para poder ejecutar este. El comando a ejecutar desde la carpeta raíz para importar los registros en Mongo es:
```
./resources/import_distances.sh
```
A lo cual debería responder algo similar a:
```
2020-11-29T18:52:55.335+0100	connected to: mongodb://localhost/
2020-11-29T18:52:55.643+0100	4696 document(s) imported successfully. 0 document(s) failed to import.
MongoDB shell version v4.4.1
connecting to: mongodb://127.0.0.1:27017/agile_data_science?compressors=disabled&gssapiServiceName=mongodb
Implicit session: session { "id" : UUID("47556e9c-ff49-48f9-9fba-a44555aa2b54") }
MongoDB server version: 4.4.1
{
	"numIndexesBefore" : 2,
	"numIndexesAfter" : 2,
	"note" : "all indexes already exist",
	"ok" : 1
}
```

## Modelo con Spark
En primer lugar es importante tener declaradas las variables de entorno JAVA_HOME y SPARK_HOME. Debería ser algo similar a:
```
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_191.jdk/Contents/Home 
export SPARK_HOME=/path_to_spark/spark-2.4.0-bin-hadoop2.7 
```

Ya se puede proceder a entrenar el modelo:
```
python3 resources/train_spark_mllib_model.py .
```

El resultado es que en la carpeta /models se crean todos los modelos.

Posteriormente, en la clase de Scala MakePrediction se cambia el valor base_path por el path de la raíz del proyecto:
```
val base_path= "/path_to_project/practica_big_data_2020" 
```

## Ejecución con Spark-Submit
En primer lugar, dentro de flight_prediction nos aseguramos que en el fichero build.sbt estén las versiones utilizadas. Una vez hecho esto, ejecutamos los dos siguientes comandos:
```
sbt compile
sbt package
```

Como resultado, se genera una carpeta /target, y si buceamos por ella hasta /target/scala-2.11, vemos que se ha generado un fichero .jar, el cual se va a emplear en el siguiente comando de Spark-submit para ejecutar el predictor de vuelos. Este comando se ejecuta desde la carpeta de Spark descargada:
```
bin/spark-submit --class es.upm.dit.ging.predictor.MakePrediction --master local --packages org.mongodb.spark:mongo-spark-connector_2.11:2.3.2,org.apache.spark:spark-sql-kafka-0-10_2.11:2.4.0 /path_to_practica/flight_prediction/target/scala-2.11/flight_prediction_2.11-0.1.jar
```

## Servidor Web
Una vez se ha ejecutado el predictor de vuelos, para lanzar el servidor web de Flask, primero hay que añadir una variable de entorno con la ubicación de la carpeta raíz del proyecto:
```
export PROJECT_HOME=/path_to_project/practica_big_data_2020 
```

Ejecutamos el servidor web:
```
python3 predict_flask.py
```

# Despliegue en dockers con docker-compose
 
En lugar de ejecutarlo en local, se va a proceder a dockerizar los diferentes servicios del sistema.

Para ello es necesario tener [Docker](https://docs.docker.com/install/) instalado.

Una vez instalado, se procederá a ejecutar el script con sh llamado scriptDockerFiles_compose.sh. El cual construye las cuatro imagenes dockerizadas: Kafka, el servidor, spark y mongo; y ejecuta el docker-compose.yml.

```
sh scriptDockerFiles_compose.sh
```
Este script tarda varios minutos en ejecutarse. 


Cuando se hayan desplegado todos los dockers, debemos ejecutar algunos comandos en cada uno de ellos (como en el despliegue local). Sin embargo para no tener que acceder directamente a sus consolas, usaremos el comando  ```docker exec``` para ejecutarlos desde nuestro terminal.

En una nueva pestaña del terminal ejecuta el siguiente comando para empezar zookeeper:
```
docker exec -it kafka_p1 /opt/kafka_2.12-2.3.0/bin/zookeeper-server-start.sh /opt/kafka_2.12-2.3.0/config/zookeeper.properties

```
A su vez, en otra pestaña:
```
docker exec -it kafka_p1 /opt/kafka_2.12-2.3.0/bin/kafka-server-start.sh /opt/kafka_2.12-2.3.0/config/server.properties

```
Y en otra nueva, para crear el topic:
```
docker exec -it kafka_p1 /opt/kafka_2.12-2.3.0/bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic flight_delay_classification_request

```
Depe aparecer por pantalla que se ha creado el topic "flight_delay_classification_request". 

En la misma consola, se debe ejecutar mongo:
```
docker exec -it mongo mongoimport -d agile_data_science -c origin_dest_distances --file /practica_big_data_2019/data/origin_dest_distances.jsonl

```

Ahora se debe proceder a ejecutar spark-submit con el comando:

```
docker exec -it spark_p1 /opt/spark-2.4.0-bin-hadoop2.7/bin/spark-submit --class es.upm.dit.ging.predictor.MakePrediction --packages org.mongodb.spark:mongo-spark-connector_2.11:2.3.2,org.apache.spark:spark-sql-kafka-0-10_2.11:2.4.0 /practica/flight_prediction/target/scala-2.11/flight_prediction_2.11-0.1.jar

```
Este comando, puede tardar unos minutos en desplegar la conexión con kafka y mongo. Una vez aparezca en salida diferentes logs de INFO Fetcher:583 es que la conexión está ya establecida.

Por último, en una nueva pestaña, desplegaremos la aplicación web gracias a flask con el comando:

```
docker exec -it server_p1 python3 /resources/web/predict_flask.py
```

Una vez se haya desplegado la web, podremos acceder a ella en http://localhost:5000/flights/delays/predict_kafka , donde podremos cambiar los diferentes parametros de entrada de la predicción de vuelos, y obtendremos el resultado







