FROM node:6-wheezy

LABEL maintainer="bolek@zeepeetek.pl"


ENV DB_HOST 127.0.0.1
ENV DB_PASSWORD 123456
ENV CHANNEL_NAME mychannel
ENV PEER_LISTEN_ADDRESS 127.0.0.1:7051
ENV PEER_EVENT_SEVICE_ADDRESS 127.0.0.1:7053
ENV PEER_HOSTNAME peer0.org1.example.com
ENV CACERT_PATH /first-network/crypto-config/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
ENV ADMIN_KEYSTORE_PATH /first-network/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/keystore
ENV ADMIN_CERTFILE_PATH /first-network/crypto-config/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp/signcerts

RUN apt-get update && \
	echo 'mysql-server mysql-server/root_password password 123456' | debconf-set-selections && \
	echo 'mysql-server mysql-server/root_password_again password 123456' | debconf-set-selections && \
	apt-get -y install mysql-server

RUN git clone https://github.com/hyperledger/blockchain-explorer.git /opt/blockchain-explorer

VOLUME /opt/blockchain-explorer/msp

WORKDIR /opt/blockchain-explorer

EXPOSE 8080

RUN npm install

COPY blockchain-explorer.sh /opt/blockchain-explorer

RUN chmod +x blockchain-explorer.sh

CMD ["./blockchain-explorer.sh"]