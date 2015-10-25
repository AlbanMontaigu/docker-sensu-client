# docker-sensu-client

## Introduction

Thanks to initial project : [usmanismail/docker-sensu-client](https://github.com/usmanismail/docker-sensu-client)

## Installation

Install from docker index or build from Dockerfile

```
docker pull amontaigu/sensu-client
```

or

```
git clone https://github.com/AlbanMontaigu/docker-sensu-client.git
cd docker-sensu-client
docker build -t yourname/sensu-client .
```

## Run

```
docker run -d amontaigu/sensu-client SERVER_IP RABIT_MQ_USER RABIT_MQ_PASSWORD CLIENT_NAME CLIENT_IP
```

