# Documentation here: https://docs.docker.com/reference/builder/
FROM ubuntu

# Install essential tools
RUN apt-get update -q
RUN apt-get install vim tmux git curl zsh -yq
RUN chsh -s /bin/zsh

# Install Java 8
RUN apt-get install software-properties-common python-software-properties --no-install-recommends -y
RUN apt-add-repository ppa:webupd8team/java
RUN apt-get update -q
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install oracle-java8-installer --no-install-recommends -y
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Install Hadoop (HDFS + tools) [https://hadoop.apache.org/releases.html]
RUN curl http://apache.crihan.fr/dist/hadoop/core/current/hadoop-2.7.1.tar.gz | tar -xz
RUN ln -s hadoop-2.7.1 hadoop
ENV HADOOP_HOME /usr/local/hadoop

# Install Spark [http://apache.mirrors.ovh.net/ftp.apache.org/dist/spark/spark-1.5.1/]
RUN curl http://d3kbcqa49mib13.cloudfront.net/spark-1.5.1-bin-without-hadoop.tgz | tar -xz
RUN ln -s spark-1.5.1-bin-without-hadoop spark

# Slim the image a little bit
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#Prepare the ENV
ENV SPARK_DIST_CLASSPATH=/hadoop-2.7.1/etc/hadoop:/hadoop-2.7.1/share/hadoop/common/lib/*:/hadoop-2.7.1/share/hadoop/common/*:/hadoop-2.7.1/share/hadoop/hdfs:/hadoop-2.7.1/share/hadoop/hdfs/lib/*:/hadoop-2.7.1/share/hadoop/hdfs/*:/hadoop-2.7.1/share/hadoop/yarn/lib/*:/hadoop-2.7.1/share/hadoop/yarn/*:/hadoop-2.7.1/share/hadoop/mapreduce/lib/*:/hadoop-2.7.1/share/hadoop/mapreduce/*:/hadoop-2.7.1/etc/hadoop:/hadoop-2.7.1/share/hadoop/common/lib/*:/hadoop-2.7.1/share/hadoop/common/*:/hadoop-2.7.1/share/hadoop/hdfs:/hadoop-2.7.1/share/hadoop/hdfs/lib/*:/hadoop-2.7.1/share/hadoop/hdfs/*:/hadoop-2.7.1/share/hadoop/yarn/lib/*:/hadoop-2.7.1/share/hadoop/yarn/*:/hadoop-2.7.1/share/hadoop/mapreduce/lib/*:/hadoop-2.7.1/share/hadoop/mapreduce/*:/hadoop/bin/hadoop:/usr/local/hadoop/contrib/capacity-scheduler/*.jar:/usr/local/hadoop/contrib/capacity-scheduler/*.jar
ENV PATH=/hadoop/bin/:/spark/bin/:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
ENV HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"
# RUN export SPARK_DIST_CLASSPATH=$(hadoop classpath)
# RUN export PATH=/hadoop/bin/:/spark/bin/:$PATH

# Add practical scripts to play within the container
ADD scripts/getIpOnInterface.sh /spark/getIpOnInterface.sh
ADD scripts/start-master.sh /spark/start-master.sh
ADD scripts/start-shell.sh /spark/start-shell.sh
ADD scripts/start-worker.sh /spark/start-worker.sh
ADD scripts/getIpOnInterface.sh /spark/getIpOnInterface.sh

WORKDIR /spark