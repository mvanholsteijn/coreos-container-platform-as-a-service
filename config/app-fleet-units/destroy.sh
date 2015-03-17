#!/bin/bash
if [ $# -ne 1 ] ; then
	echo "USAGE: destroy unit-name" >&2
	exit 1
fi

UNITS=$(fleetctl list-units -fields=unit -no-legend | grep $1)
TEMPLATES=$(echo $UNITS | sed -e 's/@[0-9]*.*//' | sort -u)

for unit in $UNITS; do
	echo "INFO: stopping $unit..." >&2
	fleetctl destroy $unit
done

for unit in $TEMPLATES; do
	 echo "INFO: destroying template $unit@..." >&2
	fleetctl destroy $unit\@
done
