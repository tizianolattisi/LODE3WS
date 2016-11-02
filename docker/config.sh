#!/usr/bin/env bash

sed -i 's/localhost/'"$LODE3MONGO_PORT_27017_TCP_ADDR"'/' /usr/src/app/bin/www
