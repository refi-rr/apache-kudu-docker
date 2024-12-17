# BigData and Datawarehouse architectures

Immersed in the task of finding alternatives that allow having a data warehouse without having to incur high or additional costs to the already contained infrastructure.

## Kudu
### Introduction
In order to evaluate Kudu and its connection with the rest of the tools that we have, I am in the task of installing Kudu completely in containers.

Following Kudu's quickstart: [Apache Kudu Quickstart] (https://kudu.apache.org/docs/quickstart.html)
Initiate the assembly of a small test cluster.

Supported by the example: [Apache Impala Quickstart] (https://github.com/apache/kudu/tree/master/examples/quickstart/impala) I picked up impala next to the kudu cluster.

Kudu has tight integration with Apache Impala, allowing you to use Impala to insert, query, update, and delete data from Kudu Tables using Impala SQL syntax, as an alternative to using the Kudu APIs to create a custom Kudu application.

And to be able to consult it graphically, I added Hue following the following instructions: [Cloudera- Hue Server] (https://github.com/cloudera/hue/tree/testing/tools/docker/hue).

### Deployment steps by step
Create a specific folder for the different configuration files and the compose. For example: __/home/docker/kudu__
There you must create a __conf__ folder where we will save all the configuration files used by Hue.

Set the KUDU_QUICKSTART_IP variable:
```
export KUDU_QUICKSTART_IP = $ (ifconfig | grep "inet" | grep -Fv 127.0.0.1 | awk '{print $ 2}' | tail -1)
```

Copy the files: docker-compose.yml, startup.sh, conf/hue.ini and conf/init.sql

Start the cluster:

```
# docker-compose up -d
```

To run a test with impala-shell connected to kudu, we must enter the container that is running with impala:

```
# docker exec -it kudu-impala impala-shell
```

There we can run different tests like those found on the web: [Using Apache Kudu with Apache Impala] (https://kudu.apache.org/docs/kudu_impala_integration.html)

```SQL

-- Create first table
CREATE TABLE my_first_table
(
  id BIGINT,
  name STRING,
  PRIMARY KEY (id)
)
PARTITION BY HASH PARTITIONS 4
STORED AS KUDU;

-- Insert simple row
INSERT INTO my_first_table VALUES (99, "sarah");
SELECT * FROM my_first_table;

-- Insert multiple rows.
INSERT INTO my_first_table VALUES (1, "john"), (2, "jane"), (3, "jim");
SELECT * FROM my_first_table;

-- Update a row.
UPDATE my_first_table SET name = "bob" where id = 3;
SELECT * FROM my_first_table;

-- Use upsert to insert a new row and update another.
UPSERT INTO my_first_table VALUES (3, "bobby"), (4, "grant");
SELECT * FROM my_first_table;

-- Delete a row.
DELETE FROM my_first_table WHERE id = 99;
SELECT * FROM my_first_table;

-- Delete multiple rows.
DELETE FROM my_first_table WHERE id <3;
SELECT * FROM my_first_table;


CREATE TABLE new_table
PRIMARY KEY (ts, name)
PARTITION BY HASH (name) PARTITIONS 8
STORED AS KUDU
AS SELECT id, name FROM my_first_table;

```

To view the Kudu web interface, access: http://myHost:8050/

To view the Impala web interface, go to: http://myHost:25000/

To access Hue access: http://myHost:8888/

The first time you enter Hue, it asks you to enter the username and password that will be set as administrator.

### Problems with Hue
When entering Hue the error already appears:

_Malformed THandleIdentifier (guid size: 17, expected 16, secret size: 17, expected 16)_

The problem was solved thanks to the help of the Cloudera / hue community with the implementation of a new version. Resolution in the following link:
https://github.com/cloudera/hue/issues/1961


