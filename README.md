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

#### Pull image and create a folder for your Project

The image is called ```kafkasparkgio ``` and is available from DockerHub (Note: image is 7.7GB, make sure you have a reasonably good Internet conection).

To install the image, use the standard ```docker pull``` command 

```
docker pull giobbu/kafkasparkgio
```

Create a folder and cd into it.

```
mkdir Folder_Geospatial_KafkaSpark 
cd Folder_Geospatial_KafkaSpark 
```

Git clone the repository for the course

```
git clone https://github.com/giobbu/Geospatial_KafkaSpark
```

Cd to the `Geospatial_KafkaSpark` folder

```
cd Geospatial_KafkaSpark
```

Finally, give recursive permission to all for writing to it (ease the sharing with Docker container)

```
chmod -R a+rwx .
```

The Docker container should now be able to read/write to your **host ```Geospatial_KafkaSpark``` folder**.

### 3.2. Start container

### 3.2.1. Start Docker container

From the ```Geospatial_KafkaSpark ``` folder, start the container with

```
docker run -v `pwd`:/home/guest/host -p 8888:8888 -p 4040:4040 -p 23:22 -it giobbu/kafkasparkgio bash

```

Notes

* -v is used to share folder (right permissions given above will allow your changes to be saved on your computer). The "-v pwd:/home/guest/host" shares the local folder (i.e. folder containing Dockerfile, ipynb files, etc...) on your computer; 
* -it starts the Docker container in interactive mode, so you can use the console and Bash;
* -p is for sharing ports between the container and the host. 8888 is the notebook port, and 4040 the Spark UI port.

SSH allows to get a onnection to the container

```
ssh -p 23 guest@containerIP
```

where 'containerIP' is the IP of th container (127.0.0.1 on Linux). Password is 'guest'.


### 3.2.2. Start Streaming Services 

Once run, you are logged in as root in the container. Run the startup_script.sh (in /usr/bin) to start

* SSH server. You can connect to the container using user 'guest' and password 'guest'
* Zookeeper server
* Kafka server

```
startup_script.sh
```