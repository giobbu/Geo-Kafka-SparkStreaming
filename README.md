# Docker container for Kafka - Spark Streaming (PySpark)

This Dockerfile sets up a complete streaming environment for experimenting with Kafka and Spark streaming (PySpark). It installs

* Kafka 2.4.0
* Spark 2.4.4 

It additionnally installs

* Anaconda distribution for Python 3.7
* Jupyter notebook for Python 
* Geopandas python package for geospatial data

#### Container configuration details

The container is based on CentOS 6 Linux distribution. The main steps of the building process are

* Install some common Linux tools (wget, unzip, tar, ssh tools, ...), and Java (1.8)
* Create a guest user (UID important for sharing folders with host!, see below), and install Spark and sbt, Kafka, Anaconda and Jupyter notbooks for the guest user
* Go back to root user, and install startup script (for starting SSH and Cassandra services), sentenv.sh script to set up environment variables (JAVA, Kafka, Spark, ...), spark-default.conf, and Cassandra 


#### User UID

In the Dockerfile, the line

```
RUN useradd guest -u 1000
```

creates the user under which the container will be run as a guest user. The username is 'guest', with password 'guest', and the '-u' parameter sets the linux UID for that user.

In order to make sharing of folders easier between the container and your host, **make sure this UID matches your user UID on the host**. You can see what your host UID is with

```
echo $UID
```


to start using the docker container follow:

* 1) Build and run the container
* 2) Quick container start-up 

## 1) Build and run the container 

### Clone this repository

```
$ git clone https://github.com/kafkasparkgio
```

### Build

From Dockerfile folder, run

```
docker build -t kafkasparkgio .
```

It may take some time to complete.

### Run

```
docker run -v `pwd`:/home/guest/host -p 4040:4040 -p 8888:8888 -p 23:22 -ti --privileged kafkasparkgio
```


## 2) Quick container start-up 

Run container using [DockerHub image](https://hub.docker.com/giobbu/kafkasparkgio)

```
docker run -p 4040:4040 -p 8888:8888 -p 23:22 -ti --privileged kafkasparkgio
```

Note that any changes you make in the notebook will be lost once you exit de container. In order to keep the changes, it is necessary put your notebooks in a folder on your host, that you share with the container, using for example

### Note for 1) and 2)

* The "-v `pwd`:/home/guest/host" shares the local folder (i.e. folder containing Dockerfile, ipynb files, etc...) on your computer - the 'host') with the container in the '/home/guest/host' folder. 

* Ports are shared as follows:
    * 4040 bridges to Spark UI
    * 8888 bridges to the Jupyter Notebook
    * 23 bridges to SSH

SSH allows to get a onnection to the container

```
ssh -p 23 guest@containerIP
```

where 'containerIP' is the IP of th container (127.0.0.1 on Linux). Password is 'guest'.

## Start services

Once run, you are logged in as root in the container. Run the startup_script.sh to start

* SSH server. You can connect to the container using user 'guest' and password 'guest'
* Zookeeper server
* Kafka server

```
startup_script.sh
```

### Connect, open notebook and start streaming

Connect as user 'guest' and go to 'host' folder (shared with the host)

```
su guest
```

Start Jupyter notebook

```
notebook
```

and connect from your browser at port host:8888 (where 'host' is the IP for your host. If run locally on your computer, this should be 127.0.0.1 or 192.168.99.100, check Docker documentation)

#### Start Kafka producer

Open kafkaSendOBUData.ipynb and run all cells.

#### Start Kafka receiver

Open kafkaSparkReceive.ipynb and run cells up to start streaming.

#### Connect to Spark UI

It is available in your browser at port 4040.


