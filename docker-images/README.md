## spark images

#### based on Java:8

 - [spark-bare](/docker-images/spark-bare/Dockerfile) : image only contains spark
 - [spark-fixed-ports](/docker-images/spark-fixed-ports/Dockerfile) : spark-bare + some config
 
#### Based on Ubuntu

 - [spark-full](/docker-images/spark-full/Dockerfile) : complete spark image with haddop, sparl and hdfs

## How to use

#### Building

```shell
docker build -t randompulse/spark-bare ./spark-bare
docker build -t randompulse/spark-fixed-ports ./spark-fixed-ports
docker build -t randompulse/spark-full ./spark-full
```

#### Uploading

After the images are built, you can upload them like that:

```shell
docker push randompulse/spark-bare
docker push randompulse/spark-fixed-ports
docker push randompulse/spark-full
```