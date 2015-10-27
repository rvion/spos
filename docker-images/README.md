## spark images

 - barespark: image only contains spark
 - newspark: barespark + some config
 - easyspark: complete spark image with hdfs


#### Building

```shell
docker build -t randompulse/newspark ./newspark
docker build -t randompulse/barespark ./barespark
```

#### Uploading

After the images are built, you can upload them like that:

```shell
docker push randompulse/newspark
docker push randompulse/barespark
```

#### Using

[randompulse/newspark](https://hub.docker.com/r/randompulse/newspark/) and 
[randompulse/barespark](https://hub.docker.com/r/randompulse/barespark/) are also available on docker-hub 

You can thus run it direclty:

```shell
docker run -it --rm randompulse/barespark bash
```