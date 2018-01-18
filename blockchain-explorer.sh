#!/bin/bash

service mysql start
MYSQL_RUNNING=$(service mysql status | grep running | grep -v not | wc -l);

while [ $MYSQL_RUNNING -eq 1 ]
do
  logger -t INIT_DB -p info -s "waiting for MySQL service to start ..."
  sleep 1s
  MYSQL_RUNNING=$(/etc/init.d/mysql status | grep running | grep -v not | wc -l);
done

logger -t INIT_DB -p info -s "Restoring blockchain-explorer database"

mysql -u root -p$DB_PASSWORD -h 127.0.0.1 < db/fabricexplorer.sql

logger -t INIT_DB -p info -s "Database blockchain-explorer restored"

logger -t EXPLORER -p info -s "Updating blockchain-explorer config"

sed -i "s/127.0.0.1/$DB_HOST/g" /opt/blockchain-explorer/config.json
sed -i "s/123456/$DB_PASSWORD/g" /opt/blockchain-explorer/config.json
sed -i "s/mychannel/$CHANNEL_NAME/g" /opt/blockchain-explorer/config.json
sed -i "s/127.0.0.1:7051/$PEER_LISTEN_ADDRESS/g" /opt/blockchain-explorer/config.json
sed -i "s/127.0.0.1:7053/$PEER_EVENT_SEVICE_ADDRESS/g" /opt/blockchain-explorer/config.json
sed -i "s/peer0.org1.example.com/$PEER_HOSTNAME/g" /opt/blockchain-explorer/config.json
sed -i "s|/first-network/crypto-config/peerOrganizations/org1.example.com/peers/peer/tls/ca.crt|$CACERT_PATH|g" /opt/blockchain-explorer/config.json
sed -i "s|/first-network/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore|$ADMIN_KEYSTORE_PATH|g" /opt/blockchain-explorer/config.json
sed -i "s|/first-network/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts|$ADMIN_CERTFILE_PATH|g" /opt/blockchain-explorer/config.json

logger -t CERT -p info -s "Encoding key"
openssl x509 -outform der -in ${PWD}${CACERT_PATH} -out ${PWD}${CACERT_PATH}.crt

sed -i "s/pem/pem.crt/g" /opt/blockchain-explorer/config.json

rm -rf /tmp/fabric-client-kvs_peerOrg*

logger -t EXPLORER -p info -s "Starting blockchain-explorer"
node main.js
