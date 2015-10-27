# Apache Spark on Docker Swarm

### Swarm Configuration

#all sites must absolutely have
```shell
$cat /etc/hostname
myhostname

$cat /etc/hosts
 127.0.0.1	localhost
#127.0.1.1	myhostname #NEVER!!
 192.168.1.54	myhostname
```

#to be sure they must pass a cloudera manager install
###################################################

#on all hosts
$sudo docker daemon -H tcp://0.0.0.0:2375


#on manager host
$docker run --rm swarm create
16e6a7fc21cd5a9fae94411b692cd2cd

$docker -H tcp://0.0.0.0:2375 run -d -p 9999:2375 swarm manage token://16e6a7fc21cd5a9fae94411b692cd2cd


on every host
```shell
docker -H tcp://0.0.0.0:2375  run -d swarm join --addr=192.168.1.54:2375 token://16e6a7fc21cd5a9fae94411b692cd2cd
docker -H tcp://host1_ip:2375 run -d swarm join --addr=host1_ip:2375     token://16e6a7fc21cd5a9fae94411b692cd2cd
docker -H tcp://host1_ip:2375 run -d swarm join --addr=host2_ip:2375     token://16e6a7fc21cd5a9fae94411b692cd2cd
```
etc...

```
alias dswarm="docker -H tcp://0.0.0.0:9999"
dswarm rm -f sparkmaster
dswarm rm -f sparkworker1
dswarm rm -f sparkworkerxxx
```

#### Running:
```
dswarm run\
 --net=host -d \
 --name sparkmaster\
 randompulse/newspark:latest\
 bash -c "SPARK_MASTER_IP=\$(hostname -I | awk '{print \$1}') ./bin/spark-class org.apache.spark.deploy.master.Master"
```
or to debug:
```
dswarm run\
 --net=host --rm -it\
 --name sparkmaster\
  randompulse/newspark:latest \
  bash -c "SPARK_MASTER_IP=\$(hostname -I | awk '{print \$1}') ./bin/spark-class org.apache.spark.deploy.master.Master"
```


```
$MASTER_IP=$(dswarm inspect --format '{{ .Node.IP }}' sparkmaster)
```

```shell
$dswarm run\
 -d\
 --name sparkworker1\
 --net=host \
 randompulse/newspark:latest \
 bash -c "SPARK_LOCAL_IP=\$(hostname -I | awk '{print \$1}') ./bin/spark-class org.apache.spark.deploy.worker.Worker spark://$MASTER_IP:7077"
# same with sparkworker2 etc...
#run --rm -it to debug
```

```shell
$dswarm run\
 --rm -it\
 --net=host\
 randompulse/newspark:latest \
 bash -c "SPARK_LOCAL_IP=\$(hostname -I | awk '{print \$1}') ./bin/spark-shell --master spark://$MASTER_IP:7077"
```

#### Example scala code:

```scala
val NUM_SAMPLES=Math.pow(10,8).toInt
val count = sc.parallelize(1 until NUM_SAMPLES,40).map { i => val 
   x = Math.random() * 2 - 1
   val y = Math.random() * 2 - 1
   if (x*x + y*y < 1) 1 else 0
}.reduce(_ + _)
println("Pi is roughly " + 4.0 * count / NUM_SAMPLES)
```