# Documentation here: https://docs.docker.com/reference/builder/
FROM rvion/spark

RUN wget https://3230d63b5fc54e62148e-c95ac804525aac4b6dba79b00b39d1d3.ssl.cf1.rackcdn.com/Anaconda3-2.3.0-Linux-x86_64.sh
RUN chmod +x Anaconda3-2.3.0-Linux-x86_64.sh
RUN ./Anaconda3-2.3.0-Linux-x86_64.sh -b
RUN rm Anaconda3-2.3.0-Linux-x86_64.sh
WORKDIR /root/anaconda3
