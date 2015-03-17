#!/bin/bash
SERVICES="consul-server.service consul-server-announcer.service consul-server-registrator.service 
consul-client.service consul-client-registrator.service"

fleetctl submit $SERVICES

for service in $SERVICES; do
	fleetctl start $service
done
