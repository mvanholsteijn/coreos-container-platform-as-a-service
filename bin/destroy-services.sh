#!/bin/bash

function destroy_units() {
        pattern=$(echo $1 | sed -e 's/@.service/@[0-9]*.service/g')
	units=$(fleetctl list-units -no-legend -fields=unit | grep -e "$pattern")

	if [ -n "$units" ] ; then
		for unit in $units; do
			echo "INFO: stopping and destroying $unit..." >&2
			(fleetctl stop $unit && fleetctl destroy $unit) &
		done
	else
		echo "INFO: no units with name $1 running." >&2
	fi

	wait

        
	units=$(fleetctl list-unit-files -no-legend -fields=unit | grep -e "$pattern")
	if [ -n "$units" ] ; then
		for unit in $units; do
			echo "INFO: destroying $unit..." >&2
			(fleetctl destroy $unit) &
		done
	fi
	wait
}

if [ $# -ne 0 ] ; then
	SERVICE_FILES=$@
else
	SERVICE_FILES=$(ls *.service)
fi

for service in $SERVICE_FILES ; do
	destroy_units $service
done

