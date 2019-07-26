**Vagrant Kafka 3 nodes cluster**  

- ubuntu/xenial64
- versions: kafka_2.11-2.3.0/zookeeperd_3.4.8-1
- hardcoded private IP's(Vagrantfile)
- definition of successful deploy - created topic after kafka03 provision:
```bash
  kafka03: Created topic test.
    kafka03: Topic:test PartitionCount:3        ReplicationFactor:3     Configs:
    kafka03:    Topic: test     Partition: 0
    kafka03:    Leader: 3
    kafka03:    Replicas: 3,1,2 Isr: 3,1,2
    kafka03:    Topic: test     Partition: 1    Leader: 1       Replicas: 1,2,3 Isr: 1,2,3
    kafka03:    Topic: test     Partition: 2    Leader: 2       Replicas: 2,3,1 Isr: 2,3,1
```
To deploy:
```bash
git clone https://github.com/stereopanda/kafka-vagrant.git
cd kafka-vagrant 
vagrant up

```

Usefull commands:
```bash
echo stat | nc 127.0.0.1 2181 # Show zookeeper status
/opt/kafka/bin/kafka-topics.sh --zookeeper localhost:2181 --list
/opt/kafka/bin/kafka-topics.sh --zookeeper localhost:2181 --create --topic test --partitions 3 --replication-factor 3
/opt/kafka/bin/kafka-topics.sh --zookeeper localhost:2181 --describe
/opt/kafka/bin/kafka-console-producer.sh --broker-list 192.168.100.10:9092,192.168.100.11:9092,192.168.100.12:9092 --topic my-replicated-topic
/opt/kafka/bin/kafka-console-consumer.sh  --bootstrap-server 192.168.100.10:9092,192.168.100.11:9092,192.168.100.12:9092 --topic my-replicated-topic
```
