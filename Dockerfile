#Container for Kafka - Spark streaming - Cassandra
#IMPORTANT: If you wish to share folder between your host and this container, make sure the UID for user guest is the same as your UID
#Check https://github.com/Yannael/brufence/blob/master/docker/streaming/README.md for details
FROM centos:centos7

RUN yum -y update;
RUN yum -y clean all;

# Install basic tools
RUN yum install -y  wget dialog curl sudo lsof vim axel telnet nano openssh-server openssh-clients bzip2 passwd tar bc git unzip

#Install Java
RUN yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel 

#Create guest user. IMPORTANT: Change here UID 1000 to your host UID if you plan to share folders.
RUN useradd guest -u 1000
RUN echo guest | passwd guest --stdin

ENV HOME /home/guest
WORKDIR $HOME

USER guest

#Install Spark (Spark 2.2.2 - 02/07/2018, prebuilt for Hadoop 2.7 or higher)
RUN wget http://www-eu.apache.org/dist/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz
RUN tar xvzf spark-2.4.4-bin-hadoop2.7.tgz
RUN mv spark-2.4.4-bin-hadoop2.7 spark

ENV SPARK_HOME $HOME/spark

#Install Kafka
RUN wget http://www-eu.apache.org/dist/kafka/2.3.0/kafka_2.12-2.3.0.tgz
RUN tar xvzf kafka_2.12-2.3.0.tgz
RUN mv kafka_2.12-2.3.0 kafka

ENV PATH $HOME/spark/bin:$HOME/spark/sbin:$HOME/kafka/bin:$PATH

#Install Anaconda Python distribution
RUN wget https://repo.anaconda.com/archive/Anaconda3-2019.07-Linux-x86_64.sh
RUN bash Anaconda3-2019.07-Linux-x86_64.sh -b
ENV PATH $HOME/anaconda3/bin:$PATH

#Install Kafka Python module
RUN pip install --upgrade pip
RUN pip install kafka-python

#Install geopandas
USER root
RUN yum install -y gcc

USER guest
RUN pip install geopandas
RUN conda install rtree

USER root

#Environment variables for Spark and Java
ADD setenv.sh /home/guest/setenv.sh
RUN chown guest:guest setenv.sh
RUN echo . ./setenv.sh >> .bashrc

#Startup (start Zookeeper, Kafka servers)
ADD startup_script.sh /usr/bin/startup_script.sh
RUN chmod a+x /usr/bin/startup_script.sh

#Add notebooks
ADD notebooks /home/guest/notebooks
RUN chown -R guest:guest notebooks



