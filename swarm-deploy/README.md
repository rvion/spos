# Apache Spark on Docker Swarm

#### Steps are:

  1. __Have some machines__ (physical machines or VMs or both)
     
  2. __Agregate those machines in a swarm__ with docker-machine
     (see `build-swarm-*` scripts)

     After the operation, check you have:
     ```shell
     $ docker-machine ls
     NAME             ACTIVE   DRIVER       STATE     URL   SWARM
     plop                      virtualbox   Stopped
     smaster                   virtualbox   Stopped         smaster (master)
     swarm-agent-00            virtualbox   Stopped         smaster
     ```
     
  3. __Point your docker client to talk to the swarm __
     Assuming `smaster` is the name of the host running smaster:
     ```shell
     eval $(docker-machine env --swarm smaster)
     ```
     
  4. __play with docker-compose__: `docker-compose ` {up, scale, logs, restart, etc.}

     :warning: ensure you correctly `stop` and `rm` containers when you want to update your services, not to restart previously created ones


:warning: Look at the scripts before running them. 
Some of them need some env variables to work properly, like 
`SPARK_MASTER_HOST`

------------

##### Example scala code:

```scala
val NUM_SAMPLES=Math.pow(10,8).toInt
val count = sc.parallelize(1 until NUM_SAMPLES,40).map { i => val
   x = Math.random() * 2 - 1
   val y = Math.random() * 2 - 1
   if (x*x + y*y < 1) 1 else 0
}.reduce(_ + _)
println("Pi is roughly " + 4.0 * count / NUM_SAMPLES)
```

##### Sample swarm output

```
$ dswarm info

    Containers: 9
    Images: 34
    Role: primary
    Strategy: spread
    Filters: affinity, health, constraint, port, dependency
    Nodes: 3
     olivier-All-Series: 192.168.1.54:2375
      └ Containers: 3
      └ Reserved CPUs: 0 / 8
      └ Reserved Memory: 0 B / 32.93 GiB
      └ Labels: executiondriver=native-0.2, kernelversion=3.16.0-49-generic, operatingsystem=Ubuntu 14.04.2 LTS, storagedriver=aufs
     olivier-Aspire-M7811: 192.168.1.28:2375 
      └ Containers: 3
      └ Reserved CPUs: 0 / 4
      └ Reserved Memory: 0 B / 8.113 GiB
      └ Labels: executiondriver=native-0.2, kernelversion=3.16.0-38-generic, operatingsystem=Ubuntu 14.04.2 LTS, storagedriver=aufs
     olivier-Bell: 192.168.1.31:2375
      └ Containers: 3
      └ Reserved CPUs: 0 / 4
      └ Reserved Memory: 0 B / 8.068 GiB
      └ Labels: executiondriver=native-0.2, kernelversion=3.16.0-30-generic, operatingsystem=Ubuntu 14.04.2 LTS, storagedriver=aufs
    CPUs: 16
    Total Memory: 49.11 GiB
    Name: b9e3aa8c1c08
```

```shell
$ dswarm 

psCONTAINER ID      IMAGE                         COMMAND                  CREATED             #STATUS              PORTS               NAMES
86aaae72adbb        randompulse/newspark:latest   "bash -c './bin/spark"   4 minutes ago       Up 4 minutes                            olivier-Bell/sparkshell
a71abbcd93de        randompulse/newspark:latest   "bash -c './bin/spark"   4 minutes ago       Up 4 minutes                            olivier-All-Series/sparkworker2
ba404256c879        randompulse/newspark:latest   "bash -c './bin/spark"   4 minutes ago       Up 4 minutes                            olivier-Aspire-M7811/sparkworker3
21e1c4c53ecf        randompulse/newspark:latest   "bash -c './bin/spark"   4 minutes ago       Up 4 minutes                            olivier-Bell/sparkworker1
8e05ddc61449        randompulse/newspark:latest   "bash -c './bin/spark"   4 minutes ago       Up 4 minutes                            olivier-Aspire-M7811/sparkmaster

```

##### reminder:

```shell
# $0 is the name of the command
# $1 first parameter
# $2 second parameter
# $3 third parameter etc. etc
# $# total number of parameters
# $@ all the parameters will be listed
```