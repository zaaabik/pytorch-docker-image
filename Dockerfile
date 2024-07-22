FROM pytorch/pytorch:2.0.1-cuda11.7-cudnn8-devel


RUN apt-get update && apt-get upgrade -y
RUN apt-get install htop nano wget -y

RUN wget -q https://repos.influxdata.com/influxdata-archive_compat.key
RUN echo '393e8779c89ac8d958f81f942f9ad7fb82a25e133faddaf92e15b16e6ac9ce4c influxdata-archive_compat.key' | sha256sum -c && cat influxdata-archive_compat.key | gpg --dearmor | tee /etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg > /dev/null
RUN echo 'deb [signed-by=/etc/apt/trusted.gpg.d/influxdata-archive_compat.gpg] https://repos.influxdata.com/debian stable main' | tee /etc/apt/sources.list.d/influxdata.list
RUN apt-get update
RUN apt-get install telegraf tmux curl -y

ARG VERSION=1.1.0
RUN wget https://github.com/utkuozdemir/nvidia_gpu_exporter/releases/download/v${VERSION}/nvidia_gpu_exporter_${VERSION}_linux_x86_64.tar.gz
RUN tar -xvzf nvidia_gpu_exporter_${VERSION}_linux_x86_64.tar.gz
RUN mv nvidia_gpu_exporter /usr/bin

RUN pip install jupyterlab

COPY ./monitor/telegraf.conf /etc/telegraf/telegraf.conf
COPY start.sh .
EXPOSE 40100 40101 40102
ENTRYPOINT bash start.sh
