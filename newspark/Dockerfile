#see epahomov on docker
FROM randompulse/barespark

ENV SPARK_MASTER_OPTS="-Dspark.driver.port=7001 -Dspark.fileserver.port=7002 -Dspark.broadcast.port=7003 -Dspark.replClassServer.port=7004 -Dspark.blockManager.port=7005 -Dspark.executor.port=7006 -Dspark.ui.port=4040 -Dspark.broadcast.factory=org.apache.spark.broadcast.HttpBroadcastFactory" 
ENV SPARK_WORKER_OPTS="-Dspark.driver.port=7001 -Dspark.fileserver.port=7002 -Dspark.broadcast.port=7003 -Dspark.replClassServer.port=7004 -Dspark.blockManager.port=7005 -Dspark.executor.port=7006 -Dspark.ui.port=4040 -Dspark.broadcast.factory=org.apache.spark.broadcast.HttpBroadcastFactory" 

ENV SPARK_MASTER_PORT 7077 
#8080 is taken by rancher
ENV SPARK_MASTER_WEBUI_PORT 8082 
ENV SPARK_WORKER_PORT 8888 
ENV SPARK_WORKER_WEBUI_PORT 8081 
EXPOSE 4040-4049 7001 7002 7003 7004 7005 7006 7077 8080-8089 8888  
