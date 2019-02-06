#################################################
# Nutzliche Hacks fuer HDFS Administration
#################################################

################################################################
# Each command has to be executed with sudo and kerberos tocken 
################################################################
# sudo -u hdfs /BIGDATA/bin/with_hdfs_kinit hdfs dfs -put /export/home/vpoliako/hdp_example/*.csv /user/hdfs/data
#  	|              					|		|
#	|								|		+--> hdfs (Hadoop) command "dfs -put" all *.csv file from <user_folder> to <Hadoop_folder>
#	|								|	
#	|								+--> get / generate kerberos tocken/ticket
#	|
#   +--> execute with sudo as hdfs user

# put data in Hadoop HDFS
sudo -u hdfs /BIGDATA/bin/with_hdfs_kinit hdfs dfs -put /export/home/vpoliako/hdp_example/*.csv /user/hdfs/data
# list data in Hadoop HDFS
sudo -u hdfs /BIGDATA/bin/with_hdfs_kinit hdfs dfs -ls /user/hdfs/data/
# disk usage
sudo -u hdfs /BIGDATA/bin/with_hdfs_kinit hdfs dfs -df -h /

# Ambari Access (Port 8080)
http://gf0vsxbd016e.corp.int:8080/

# Ranger Access (Port 6080)
http://gf0vsxbd016e.corp.int:6080/

# show Kerberos config
cat /etc/krb5.conf

# show Kerberos ticket kash
klist

# connect to Hive with Kerberos tocken/ticket via beeline (Hive jdbc client) as hdfs user
sudo su - hdfs
kinit -kt /etc/security/keytabs/hdfs.headless.keytab hdfs # get kerberos tocken/ticket
beeline -u  "jdbc:hive2://gf0vsxbd016e.corp.int:10001/txm;principal=hive/gf0vsxbd016e.corp.int@SEU16.BIGDATA.CORP.INT;transportMode=http;httpPath=cliservice"

################################################################
# HIVE Adminis
################################################################

# list of csv file in HDFS /user/hdfs/data/geolocation.csv
sudo -u hdfs /BIGDATA/bin/with_hdfs_kinit hdfs dfs -cat /user/hdfs/data/geolocation.csv | head

truckid,driverid,event,latitude,longitude,city,state,velocity,event_ind,idling_ind
A54,A54,normal,38.440467,-122.714431,Santa Rosa,California,17,0,0
A20,A20,normal,36.977173,-121.899402,Aptos,California,27,0,0
A40,A40,overspeed,37.957702,-121.29078,Stockton,California,77,1,0
...

create database if not exists hdp_sample;

create external table if not exists hdp_sample.geolocation(
    truckid    STRING,
	driverid   STRING,
	event      STRING,
	latitude   DECIMAL (10,7),
	longitude  DECIMAL (10,7),
	city       STRING,
	state      STRING,
	velocity   INT,
	event_ind  INT,
	idling_ind INT)
	COMMENT 'Geolocation Names'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '/user/hdfs/data/'
	TBLPROPERTIES ("skip.header.line.count"="1");
	
	
# list of csv file in HDFS /user/hdfs/data/trucs.csv
sudo -u hdfs /BIGDATA/bin/with_hdfs_kinit hdfs dfs -cat /user/hdfs/data/trucks.csv | head

driverid,truckid,model,jun13_miles,jun13_gas,may13_miles,may13_gas,apr13_miles,apr13_gas,mar13_miles,mar13_gas,feb13_miles,feb13_gas,jan13_miles,jan13_gas,dec12_miles,dec12_gas,nov12_miles,nov12_gas,oct12_miles,oct12_gas,sep12_miles,sep12_gas,aug12_miles,aug12_gas,jul12_miles,jul12_gas,jun12_miles,jun12_gas,may12_miles,may12_gas,apr12_miles,apr12_gas,mar12_miles,mar12_gas,feb12_miles,feb12_gas,jan12_miles,jan12_gas,dec11_miles,dec11_gas,nov11_miles,nov11_gas,oct11_miles,oct11_gas,sep11_miles,sep11_gas,aug11_miles,aug11_gas,jul11_miles,jul11_gas,jun11_miles,jun11_gas,may11_miles,may11_gas,apr11_miles,apr11_gas,mar11_miles,mar11_gas,feb11_miles,feb11_gas,jan11_miles,jan11_gas,dec10_miles,dec10_gas,nov10_miles,nov10_gas,oct10_miles,oct10_gas,sep10_miles,sep10_gas,aug10_miles,aug10_gas,jul10_miles,jul10_gas,jun10_miles,jun10_gas,may10_miles,may10_gas,apr10_miles,apr10_gas,mar10_miles,mar10_gas,feb10_miles,feb10_gas,jan10_miles,jan10_gas,dec09_miles,dec09_gas,nov09_miles,nov09_gas,oct09_miles,oct09_gas,sep09_miles,sep09_gas,aug09_miles,aug09_gas,jul09_miles,jul09_gas,jun09_miles,jun09_gas,may09_miles,may09_gas,apr09_miles,apr09_gas,mar09_miles,mar09_gas,feb09_miles,feb09_gas,jan09_miles,jan09_gas
MA1,A1,Freightliner,9217,1914,8769,1892,14234,3008,11519,2262,8676,1596,10025,1878,12647,2331,10214,2054,10807,2134,11127,2191,9754,1967,12925,2578,15792,3313,9052,1878,11062,2150,13594,2824,11019,2324,9222,1902,8565,1745,10410,1943,13450,3047,10446,2112,10378,2201,9014,1598,9466,2642,14175,2642,11573,2642,13055,2642,14614,2642,14099,2642,15174,2642,10635,2642,12105,2642,10130,2642,11344,2642,10622,2642,10747,2642,12976,2642,13221,2642,10435,2642,12839,2642,8969,2642,8795,2642,13668,2642,12414,2642,13300,2642,11698,2642,14207,2642,14062,2642,12073,2642,15276,2642,9880,2642,13861,2642,11176,2642
MA2,A2,Ford,12058,2335,14314,2648,11050,2323,14114,3157,13583,2346,15362,3353,13608,2607,11236,2597,11380,1939,12934,2324,11848,2301,13206,3114,15316,3344,13838,2718,12024,2800,12693,2329,14392,2929,11134,2290,13911,2953,11542,2650,11296,2135,10224,2027,14595,3013,13769,2980,10377,1827,12786,1827,14364,1827,8978,1827,9259,1827,9545,1827,13100,1827,8529,1827,9667,1827,13264,1827,12070,1827,10367,1827,13829,1827,10942,1827,10463,1827,9406,1827,14755,1827,14043,1827,11656,1827,14744,1827,13797,1827,9660,1827,10283,1827,12034,1827,11719,1827,13912,1827,11892,1827,15158,1827,12774,1827,11743,1827

create external table if not exists hdp_sample.trucks(
    driverid      STRING,
	truckid       STRING,
	model         STRING,
	jun13_miles   INT,
	jun13_gas     INT,
	may13_miles	  INT,
	may13_gas	  INT,
	apr13_miles	  INT,
	apr13_gas     INT,
	mar13_miles   INT,
	mar13_gas     INT,
	feb13_miles   INT,
	feb13_gas     INT,
	jan13_miles   INT,
	jan13_gas     INT,
	dec12_miles   INT,
	dec12_gas     INT,
	nov12_miles   INT,
	nov12_gas	  INT,
	oct12_miles   INT,
	oct12_gas     INT,
	sep12_miles   INT,
	sep12_gas     INT,
	aug12_miles   INT,
	aug12_gas     INT,
	jul12_miles   INT,
	jul12_gas     INT,
	jun12_miles   INT,
	jun12_gas     INT,
	may12_miles   INT,
	may12_gas     INT,
	apr12_miles   INT,
	apr12_gas     INT,
	mar12_miles   INT,
	mar12_gas     INT,
	feb12_miles   INT,
	feb12_gas     INT,
	jan12_miles   INT,
	jan12_gas     INT,
	dec11_miles   INT,
	dec11_gas     INT,
	nov11_miles   INT,
	nov11_gas     INT,
	oct11_miles   INT,
	oct11_gas     INT,
	sep11_miles   INT,
	sep11_gas     INT,
	aug11_miles   INT,
	aug11_gas     INT,
	jul11_miles   INT,
	jul11_gas     INT,
	jun11_miles   INT,
	jun11_gas     INT,
	may11_miles   INT,
	may11_gas     INT,
	apr11_miles   INT,
	apr11_gas     INT,
	mar11_miles   INT,
	mar11_gas     INT,
	feb11_miles   INT,
	feb11_gas     INT,
	jan11_miles   INT,
	jan11_gas     INT,
	dec10_miles   INT,
	dec10_gas     INT,
	nov10_miles   INT,
	nov10_gas     INT,
	oct10_miles   INT,
	oct10_gas     INT,
	sep10_miles   INT,
	sep10_gas     INT,
	aug10_miles   INT,
	aug10_gas     INT,
	jul10_miles   INT,
	jul10_gas     INT,
	jun10_miles   INT,
	jun10_gas     INT,
	may10_miles   INT,
	may10_gas     INT,
	apr10_miles   INT,
	apr10_gas     INT,
	mar10_miles   INT,
	mar10_gas     INT,
	feb10_miles   INT,
	feb10_gas     INT,
	jan10_miles   INT,
	jan10_gas     INT,
	dec09_miles   INT,
	dec09_gas     INT,
	nov09_miles   INT,
	nov09_gas     INT,
	oct09_miles   INT,
	oct09_gas     INT,
	sep09_miles   INT,
	sep09_gas     INT,
	aug09_miles   INT,
	aug09_gas     INT,
	jul09_miles   INT,
	jul09_gas     INT,
	jun09_miles   INT,
	jun09_gas     INT,
	may09_miles   INT,
	may09_gas     INT,
	apr09_miles   INT,
	apr09_gas     INT,
	mar09_miles   INT,
	mar09_gas     INT,
	feb09_miles   INT,
	feb09_gas     INT,
	jan09_miles   INT,
	jan09_gas)
	COMMENT 'Trucks Information'
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '/user/hdfs/data/'
	TBLPROPERTIES ("skip.header.line.count"="1");