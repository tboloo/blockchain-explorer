# Hyperledger Explorer docker alpine image
# https://github.com/hyperledger/blockchain-explorer
# env variables required:
# HTTP_PORT=<web server port. Default is 9090 if not set>
# HYP_REST_ENDPOINT=<REST endpoint. Default is http://127.0.0.1:7050 if not set>

FROM node:7-alpine
LABEL maintainer="Bolek Tekielski <bolek@zeepeetek.pl>"

ENV POSTGRES_HOST=172.17.0.7 \
	POSTGRES_PORT=5432 \
	POSTGRES_USER=postgres \
	POSTGRES_PASSWORD=postgres \
	HTTP_PORT=3000

ENV WORKINGDIR=/var/blockchain-explorer

# -----------------------------------------------------------------------------
# Installation
# -----------------------------------------------------------------------------
RUN apk add --no-cache git bash postgresql-client python --virtual build-dependencies build-base

RUN git clone --single-branch -b release-3.1 --depth 1 https://github.com/hyperledger/blockchain-explorer.git ${WORKINGDIR}

WORKDIR ${WORKINGDIR}

RUN npm install

COPY run_server.sh ${WORKINGDIR}/

VOLUME ${WORKINGDIR}

EXPOSE ${HTTP_PORT}

CMD ["/bin/sh", "run_server.sh"]
