#!/bin/bash

ln -s /usr/bin/python3 /usr/bin/python
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart ssh
echo  "Disablinvag  g IPv6"
echo "net.ipv6.conf.all.disable_ipv6 = 1
      net.ipv6.conf.default.disable_ipv6 = 1
      net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf
sysctl -p
apt-get -y update
apt-get -y install openjdk-8-jdk
apt-get -y install zookeeperd
wget http://mirror.cogentco.com/pub/apache/kafka/2.3.0/kafka_2.11-2.3.0.tgz
tar -xzf kafka_2.11-2.3.0.tgz
mkdir /opt/kafka
cp -r kafka_*/* /opt/kafka

cat << EOF >>  /etc/systemd/system/kafka.service
[Unit]
Description=Apache Kafka server (broker)
Documentation=http://kafka.apache.org/documentation.html
Requires=network.target remote-fs.target
After=network.target remote-fs.target kafka-zookeeper.service

[Service]
Type=fork
ExecStart=/opt/kafka/bin/kafka-server-start.sh /opt/kafka/config/server.properties
ExecStop=/opt/kafka/bin/kafka-server-stop.sh
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

echo '3' > /etc/zookeeper/conf/myid

echo "server.1=192.168.100.10:2888:3888
server.2=192.168.100.11:2888:3888
server.3=192.168.100.12:2888:3888" >> /etc/zookeeper/conf/zoo.cfg

sed  -i '/zookeeper.connect=.*/d' /opt/kafka/config/server.properties
sed  -i 's/broker.id=0/broker.id=3/' /opt/kafka/config/server.properties


echo " " >> /opt/kafka/config/server.properties
echo "zookeeper.connect=192.168.100.10:2181,192.168.100.11:2181,192.168.100.12:2181" >> /opt/kafka/config/server.properties

systemctl daemon-reload
systemctl restart zookeeper
systemctl restart kafka
#echo "Hello, World" | /opt/kafka/bin/kafka-console-producer.sh --broker-list localhost:9092 --topic Hello_World_Topic_is_ready > /dev/null
#/opt/kafka/bin/kafka-topics.sh --zookeeper localhost:2181 --list

sleep 10
/opt/kafka/bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic test --partitions 3 --replication-factor 3
/opt/kafka/bin/kafka-topics.sh --zookeeper localhost:2181 --describe