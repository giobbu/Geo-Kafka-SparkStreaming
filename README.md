# Docker container for Kafka - Spark Streaming (PySpark)

This Dockerfile sets up a complete streaming environment for experimenting with Kafka and Spark streaming (PySpark). It installs

* Kafka 2.4.0;
* Spark 2.4.4. 

It additionnally installs

* Anaconda distribution for Python 3.7;
* Jupyter notebook for Python; 
* Geopandas python package for geospatial data (http://geopandas.org/index.html).



In order to avoid building the image from scratch, a prebuilt image is made available from DockerHub, see below.

## 3. Get started

### 3.1. Pull image

#### Pull image

The image is called ```kafkasparkgio ``` and is available from DockerHub (Note: image is 7.7GB, make sure you have a reasonably good Internet conection).

To install the image, use the standard ```docker pull``` command 

```
docker pull giobbu/kafkasparkgio
```

Create a folder and cd into it.

```
mkdir PROJECT 
cd PROJECT  
```

Git clone the repository for the course

```
git clone https://github.com/Yannael/BigDataAnalytics_INFOH515
```

Cd to the `BigDataAnalytics_INFOH515` folder

```
cd BigDataAnalytics_INFOH515
```

Finally, give recursive permission to all for writing to it (ease the sharing with Docker container)

```
chmod -R a+rwx .
```

The Docker container should now be able to read/write to your host ```bda_course``` folder.

### 3.2. Start container


**From the ```BigDataAnalytics_INFOH515 ``` folder**, start the container with

```
docker run -v `pwd`:/home/guest/shared -p 8888:8888 -p 4040:4040 -it yannael/bda_advancedanalytics bash
```

Notes

* -v is used to share folder (right permissions given above will allow your changes to be saved on your computer)
* -it starts the Docker container in interactive mode, so you can use the console and Bash
* -p is for sharing ports between the container and the host. 8888 is the notebook port, and 4040 the Spark UI port
* --privileged is for Cassandra, that requires priviledged access to the host.

You are logged in as root. Change user to guest

```
su guest
cd 
```

```
docker run -p 4040:4040 -p 8888:8888 -p 23:22 -ti --privileged kafkasparkgio
```

Note that any changes you make in the notebook will be lost once you exit de container. In order to keep the changes, it is necessary put your notebooks in a folder on your host, that you share with the container, using for example

```
docker run -v `pwd`:/home/guest/host -p 4040:4040 -p 8888:8888 -p 23:22 -ti --privileged yannael/kafka-sparkstreaming-cassandra
```

### Note for 1. and 2.

* The "-v `pwd`:/home/guest/host" shares the local folder (i.e. folder containing Dockerfile, ipynb files, etc...) on your computer - the 'host') with the container in the '/home/guest/host' folder. 

* Ports are shared as follows:
    * 4040 bridges to Spark UI
    * 8888 bridges to the Jupyter Notebook
    * 23 bridges to SSH

SSH allows to get a connection to the container

```
ssh -p 23 guest@containerIP
```

where 'containerIP' is the IP of th container (127.0.0.1 on Linux). Password is 'guest'.

## Start Services

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

It is available in your browser at port 4050.


#### Container configuration details

The container is based on CentOS 6 Linux distribution. The main steps of the building process are

* Install some common Linux tools (wget, unzip, tar, ssh tools, ...), and Java (1.8);
* Create a guest user and install Spark and sbt, Kafka, Anaconda and Jupyter notbooks for the guest user;
* Go back to root user, and install startup script (for starting SSH), sentenv.sh script to set up environment variables (JAVA, Kafka, Spark, ...) and spark-default.conf.


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


