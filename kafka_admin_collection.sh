#################################################
# Nutzliche Hacks fuer Kafka Administration
#################################################

##############################################################
# Kafka status / stopp / start etc.
##############################################################
# /usr/bin/kafka-server-start hier drin wird am Ende /usr/bin/kafka-run-class verwendet um die Broker zu starten
# und in kafka-run-class findest du auch die Verwendung von KAFKA_OPTS und hier /etc/systemd/system/kafka.service setzen/überschreiben wir die Werte für den Service 
sudo systemctl status kafka
sudo systemctl stop kafka
sudo systemctl start kafka

# create topic
kafka-topics --create --zookeeper localhost:2181/kafka_seu08 --replication-factor 1 --partitions 1 --topic vladi-test

# topics auflisten
kafka-topics --list --zookeeper gf0vsxbd008e:2181/kafka_seu08
kafka-topics --list --zookeeper gf0vsxbd201l:2181/kafka_mew
kafka-topics --describe --under-replicated-partitions --zookeeper gf0vsxbd201l:2181/kafka_mew
kafka-topics --zookeeper gf0vsxbd200l.corp.int:2181,gf0vsxbd201l.corp.int:2181,gf0vsxbd202l.corp.int:2181/kafka_mew --describe --under-replicated-partitions | wc -l
kafka-topics --zookeeper gf0vsxbd200l.corp.int:2181,gf0vsxbd201l.corp.int:2181,gf0vsxbd202l.corp.int:2181/kafka_mew --describe --unavailable-partitions | wc -l
kafka-topics --create --zookeeper gf0vsxbd008e:2181/kafka_seu08 --replication-factor 1 --partitions 1 --topic eddTest
kafka-topics --describe --zookeeper gf0vsxbd008e:2181/kafka_seu08
kafka-topics --zookeeper gf0vsxbd203p.corp.int:2181/kafka_arceus --describe   kafka-topics --list --zookeeper gf0vsxbd008e:2181/kafka_seu08
# Prod Logbus
kafka-topics --list --zookeeper gf0vsxbd400p:2181/kafka_statler | grep g2p.cms.logging.audit

# consumer 
# +--> Note: This will only show information about consumers that use ZooKeeper (not those using the Java consumer API).
kafka-consumer-groups --list --zookeeper gf0vsxbd008e:2181/kafka_seu08
kafka-consumer-groups --bootstrap-server gf0vsxbd200l:9093 --describe --group thomas

# kafka-console-consumer --> read a message
kafka-console-consumer --bootstrap-server gf0vsxbd200l:9093 --topic test-metrics

# kafka-console-producer --> write a message
kafka-console-producer --broker-list gf0vsxbd201l:9093 --topic test-metrics
 
# kafka_exporter starten (https://github.com/danielqsj/kafka_exporter)
./kafka_exporter --kafka.server=gf0vsxbd201l:9093 --web.listen-address="127.0.0.1:9101" --log.level=debug --kafka.version="1.1.0" --log.enable-sarama --topic.filter=".*"

# sample producer ++++ START ++++
#!/bin/bash

counter=1

while [ $counter -le 10 ]
do
  echo $counter  
  sleep 1
  echo "test_$counter" | kafka-console-producer --broker-list gf0vsxbd201l:9093 --topic test-metrics
  ((counter++))
done
# sample producer ++++ END ++++

############################################# 
# JMX Messages
#############################################
# jmx_exporter Metriks fuer kafka auslesen
curl -s localhost:9401 | grep -i kafka | head
# get text <offset{topic="test-metrics>
curl -s http://localhost:9401/ | grep -i offset\.*test-metrics
# or
curl -s http://localhost:9401/ | grep -i offset\.topic=\"test-metrics
# get text <offset{topic="connect-test>
curl -s http://localhost:9401/ | grep -i offset\.topic=\"connect-test

####################################################
# Sample of kafka.yml file
# Formatting the kafka jmx messages in prometheus
# text plain format. One example for Lag Monitoring
####################################################
# Lag Monitoring
# # Measured in number of messages.
# # This is the differens between the last messages produced in a specific partition and
# # the last message processed by the consumer
#- pattern : kafka.log<type=(.+), name=LogEndOffset, topic=(.+), partition=(.*)><>Value
#  name: kafka_log_$1_logendoffset
#  type: GAUGE
#  labels:
#    topic: "$2"
#    partition: "$3"
#- pattern : kafka.log<type=(.+), name=LogStartOffset, topic=(.+), partition=(.*)><>Value
#  name: kafka_log_$1_logstartoffset
#  type: GAUGE
#  labels:
#    topic: "$2"
#    partition: "$3"
