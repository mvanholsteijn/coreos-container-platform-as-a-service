#!/bin/bash

function load_unit() {
	NEW_MD5=$(md5 < $1)
	LOADED=$(fleetctl list-unit-files -no-legend -fields=unit | grep $1)
	if [ -n "$LOADED" ] ; then
		CURRENT_MD5=$(fleetctl cat $1 | md5)
		if [ "$NEW_MD5" != "$CURRENT_MD5" ] ; then
			echo "INFO: unit $1 differs, destroying old one"
			fleetctl destroy $1
			echo "INFO: submitting $1.."
			fleetctl submit $1
		else
			echo "INFO: unit $1 unchanged"
		fi
	else
		echo "INFO: submitting $1.."
		fleetctl submit $1
	fi
}

function start_unit() {
	local service=$(echo $1 | sed -e 's/.service//')
	if expr "$service" : ".*@$" >/dev/null 2>&1 ; then
		service=${service}1
	fi
	echo "INFO: starting $service..."
	fleetctl start $service
}

if [ $# -ne 0 ] ; then
	SERVICE_FILES=$@
else
	SERVICE_FILES=$(ls *.service)
fi

for service in $SERVICE_FILES ; do
	load_unit $service
	start_unit $service
done

