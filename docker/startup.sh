#!/usr/bin/env bash

# ensure to apply the proper configuration
if [ ! -f /usr/src/app/LODE3WS-configured ]
then
	/usr/src/app/config.sh && touch /usr/src/app/LODE3WS-configured || exit 1
fi

exec npm start