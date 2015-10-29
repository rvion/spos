# define a few practical aliases
alias dm="docker-machine"
alias drun="docker run -it --rm"
alias drunspark="docker run -it --rm --net=host -e SPARK_LOCAL_IP=\$(dm ip \$(dm active))"
# `$(dm ip $(dm active))` gives the ip of the active host VM docker send commands to. \$ are escaped for the subcommand to re-run at each invocation

# start spark master on mmaster
eval $(dm env mmaster)
sleep 2
drunspark snufkin/spark-base ./bin/spark-class org.apache.spark.deploy.master.Master

# start first workers on mswarm1
eval $(dm env mswarm1)
sleep 2
drunspark snufkin/spark-base ./bin/spark-class org.apache.spark.deploy.worker.Worker spark://$(dm ip mmaster):7077

# start second worker on mswarm2 with an alternative way (without -e, finding SPARK_LOCAL_IP directly from within the container)
eval $(dm env mswarm2)
sleep 2
drun --net=host snufkin/spark-base bash -c "SPARK_LOCAL_IP=\$(hostname -I | awk '{print \$2}') ./bin/spark-class org.apache.spark.deploy.worker.Worker spark://$(dm ip mmaster):7077"

# start shell on mshell1
eval $(dm env mshell1)
sleep 2
drunspark snufkin/spark-base ./bin/spark-shell --master spark://$(dm ip mmaster):7077

# then, in scala:
#   val accum = sc.accumulator(0, "My Accumulator")
#   sc.parallelize(Array(1, 2, 3, 4)).foreach(x => accum += x)
#   accum.value