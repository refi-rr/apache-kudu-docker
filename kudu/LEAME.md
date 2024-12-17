# Arquitecturas BigData y Datawarehouse

Sumergido en la tarea de encontrar alternativas que permitan tener un datawarehouse sin tener que incurrir en costos elevados o adicionales a la infraestructura ya contenida. 

## Kudu
### Introducción
Para poder evaluar Kudu y su conexión con el resto de las herramientas que poseemos estoy en la tarea de instalar Kudu de manera completa en contenedores. 

Siguiendo el quickstart de Kudu: [Apache Kudu Quickstart](https://kudu.apache.org/docs/quickstart.html)
Inicie el armado de un pequeño cluster de prueba. 

Respaldado en el ejemplo: [Apache Impala Quickstart](https://github.com/apache/kudu/tree/master/examples/quickstart/impala) levanté impala junto al cluster de kudu.

Kudu tiene una estrecha integración con Apache Impala, lo que le permite usar Impala para insertar, consultar, actualizar y eliminar datos de Tablas Kudu utilizando la sintaxis SQL de Impala, como una alternativa al uso de las API de Kudu para crear una aplicación Kudu personalizada. 


y para poder consultar de manera gráfica agregué Hue siguiendo el siguiente instructivo: [Cloudera- Hue Server](https://github.com/cloudera/hue/tree/testing/tools/docker/hue) .

### Pasos a paso del despliegue
Crear una carpeta específica para los diferentes archivos de configuración y el compose. Por ejemplo __/home/docker/kudu__ .
Allí se debe crear una carpeta __conf__ donde guararemos todos los archivos de configuración utilizados por Hue.

Setear la variable KUDU_QUICKSTART_IP: 
export KUDU_QUICKSTART_IP=$(ifconfig | grep "inet " | grep -Fv 127.0.0.1 |  awk '{print $2}' | tail -1)

Copiar los archivos: docker-compose.yml, startup.sh , conf/hue.ini y conf/init.sql

inciar el cluster: 

```
# docker-compose up -d
```

Para ejecutar una prueba con impala-shell conectado a kudu, debemos ingresar al container que está corriendo con impala: 

```
# docker exec -it kudu-impala impala-shell
```

Allí podemos ejecutar diferentes pruebas como las que se encuentran en la web: [Uso de Apache Kudu con Apache Impala](https://kudu.apache.org/docs/kudu_impala_integration.html)


```SQL

-- Create first table
CREATE TABLE my_first_table
(
  id BIGINT,
  name STRING,
  PRIMARY KEY(id)
)
PARTITION BY HASH PARTITIONS 4
STORED AS KUDU;

--Insert simple row
INSERT INTO my_first_table VALUES (99, "sarah");
SELECT * FROM my_first_table;

-- Insert multiple rows.
INSERT INTO my_first_table VALUES (1, "john"), (2, "jane"), (3, "jim");
SELECT * FROM my_first_table;

-- Update a row.
UPDATE my_first_table SET name="bob" where id = 3;
SELECT * FROM my_first_table;

-- Use upsert to insert a new row and update another.
UPSERT INTO my_first_table VALUES (3, "bobby"), (4, "grant");
SELECT * FROM my_first_table;

-- Delete a row.
DELETE FROM my_first_table WHERE id = 99;
SELECT * FROM my_first_table;

-- Delete multiple rows.
DELETE FROM my_first_table WHERE id < 3;
SELECT * FROM my_first_table;


CREATE TABLE new_table
PRIMARY KEY (ts, name)
PARTITION BY HASH(name) PARTITIONS 8
STORED AS KUDU
AS SELECT id, name FROM my_first_table;

```

Para visualizar la interfaz web de Kudu, acceder a: http://myHost:8050/

Para visualizar la interfaz web de Impala, acceder a: http://myHost:25000/

Para ingresar a Hue acceder a: http://myHost:8888/

La primera vez que ingresas a Hue solicita que ingreses el usuario y contraseña que se seteará como administrador. 

### Problemas con Hue
Al ingresar a Hue ya aparece el error: 

_Malformed THandleIdentifier (guid size: 17, expected 16, secret size: 17, expected 16)_

El problema fue resuelto gracias a la ayuda de la comunidad de Cloudera/hue con la implementacion de una nueva version. Resolucion en el siguiente link:
https://github.com/cloudera/hue/issues/1961

## Citus
Citus es una versión de PostgreSQL distrubido. Que permite sumarle a la familiarizacion con postgres la potencialidad de procesamiento distribuido. 


## Presto


# Bibliografía adicional
- Cuestiones a tener en cuenta para la elección de nuevas aqruitecturas: Necesidad, Costo, Código Abierto vs. Propietario, Licencia, Madurez, Documentación, Experiencia en equipo, Tracción , Soporte y servicios : 
https://medium.com/codex/choosing-technologies-as-an-architect-8284a661f6a4#

- Documentacion de comparativa de Kudu frente a HDFS: https://blog.clairvoyantsoft.com/guide-to-using-apache-kudu-and-performance-comparison-with-hdfs-453c4b26554f
