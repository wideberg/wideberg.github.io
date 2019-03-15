#!/bin/bash

#HOST_IP=`/sbin/ip route|awk '/default/ { print $3 }'`
#echo "ip of host: $HOST_IP"
#echo "$HOST_IP  host" >> /etc/hosts

bundle install
bundle exec jekyll serve --host=`hostname -i`
