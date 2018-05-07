# Hyperledger Explorer docker alpine image
# https://github.com/hyperledger/blockchain-explorer

FROM node:9-slim
LABEL maintainer="Bolek Tekielski <bolek@zeepeetek.pl>"

ENV POSTGRES_HOST=postgres \
	POSTGRES_PORT=5432 \
	POSTGRES_USER=postgres \
	POSTGRES_PASSWORD=postgres \
	HTTP_PORT=3000

ENV WORKINGDIR=/var/blockchain-explorer

# -----------------------------------------------------------------------------
# Installation
# -----------------------------------------------------------------------------
RUN apt-get update 
RUN apt-get install -y git bash postgresql-client python build-essential

RUN git clone --single-branch -b release-3.1 --depth 1 https://github.com/hyperledger/blockchain-explorer.git ${WORKINGDIR}

WORKDIR ${WORKINGDIR}/app/test

RUN npm install

WORKDIR ${WORKINGDIR}/client

RUN npm install

RUN npm run build

WORKDIR ${WORKINGDIR}

RUN npm install

RUN npm rebuild 
# --update-binary --target_libc=glibc

COPY run_server.sh ${WORKINGDIR}/

VOLUME ${WORKINGDIR}

EXPOSE ${HTTP_PORT}

CMD ["/bin/sh", "run_server.sh"]
