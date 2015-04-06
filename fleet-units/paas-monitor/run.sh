#!/bin/bash

function get_state() {
        fleetctl list-units -fields=unit,sub -no-legend | grep "^$1" | cut -f2
}

function wait_until_unit_is_gone() {
        wait_until_state $1 '^$'
}

function wait_until_state() {
	local OLDSTATE=""
        local STATE=$(get_state $1)
        while ! (echo $STATE | egrep -q "$2"); do
		if [ "$STATE" != "$OLDSTATE" ] ; then
			test -n "$OLDSTATE" && echo
			echo  -n "$unit in state ${STATE}";
		else
			echo -n .
		fi
                sleep 1;
		OLDSTATE=$STATE
                STATE=$(get_state $1)
        done
	test -n "$OLDSTATE" && echo
	echo  "$unit in state ${STATE}.";
}

expr  "$2" : '^[1-9][0-9]*$' >/dev/null
isnumber=$?

if [ $# -eq 2 -a -f "$1" -a $isnumber -eq 0  ] ; then
	fleetctl submit $1
	COUNT=1
	while [ $COUNT -le $2 ]; do
		unit=$(basename $1 .service)$COUNT.service
		fleetctl load $unit
		COUNT=$(($COUNT + 1))
	done

	COUNT=1
	while [ $COUNT -le $2 ]; do
		unit=$(basename $1 .service)$COUNT.service
		fleetctl start $unit
		wait_until_state $unit running
		COUNT=$(($COUNT + 1))
	done
fi
