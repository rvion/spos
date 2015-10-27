# Documentation here: https://docs.docker.com/reference/builder/
FROM ubuntu

# Install essential tools
RUN apt-get update -q
RUN apt-get install vim tmux git curl zsh -yq
RUN chsh -s /bin/zsh

# Install Hadoop (HDFS + tools) [https://hadoop.apache.org/releases.html]
RUN curl http://apache.crihan.fr/dist/hadoop/core/current/hadoop-2.7.1.tar.gz | tar -xz
RUN ln -s hadoop-2.7.1 hadoop

# Install Spark [http://apache.mirrors.ovh.net/ftp.apache.org/dist/spark/spark-1.5.1/]
RUN curl http://apache.crihan.fr/dist/spark/spark-1.5.1/spark-1.5.1.tgz | tar -xz
RUN ln -s spark-1.5.1 spark

# Install Java 8
RUN apt-get install software-properties-common python-software-properties --no-install-recommends -y
RUN apt-add-repository ppa:webupd8team/java
RUN apt-get update -q
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
RUN apt-get install oracle-java8-installer --no-install-recommends -y

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV HADOOP_HOME /usr/local/hadoop

# Slim the image a little bit
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*