#!/bin/sh
filename=.env
if [ ! -f $filename ]
then
    touch $filename
fi

export PASSWORD=$(date +%s|sha256sum|base64|head -c 32)
echo 'PASSWORD='$PASSWORD > .env

export TZ=$(cat /etc/timezone)
echo 'TZ='$TZ >> .env

