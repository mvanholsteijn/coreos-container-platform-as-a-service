#!/bin/bash

#if template file has changed:
#	destroy the old template file.
#	submit the new one.

#for each unit of the template
#	if the service definition has changed:
#		stop the current unit
#		start a new unit same name
#		wait until it is running


function unit_changed() {
	NEW_MD5=$(md5 < $1)
	CURRENT_MD5=$(fleetctl cat $2 | md5)
	test "$NEW_MD5" != "$CURRENT_MD5" 
}

function update_template() {
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

function start_unit() {
        fleetctl load $1
        fleetctl start $1
	wait_until_state $1 "running"
}

function restart_unit() {
	STATE=$(get_state $1)
        if [ $STATE == "running" ] ; then
		fleetctl stop $1
		wait_until_state $1 "failed|stopped"
	fi
	fleetctl destroy $1
	wait_until_unit_is_gone $1

        start_unit $1
}

function list_all_active_units() {
        pattern=$(echo $1 | sed -e 's/@.service$/@[0-9][0-9]*.service/g')
	fleetctl list-units -fields=unit | egrep -e "$pattern"
}

function list_all_inactive_unit_files() {
        pattern=$(echo $1 | sed -e 's/@.service$/@[0-9][0-9]*.service/g')
	fleetctl list-unit-files -fields=unit,state | grep "$pattern" | grep inactive | cut -f1
}

function restart_all_active_units() {
	NEW_MD5=$(md5 < $1)
        for unit in $(list_all_active_units $1); do
		CURRENT_MD5=$(fleetctl cat $unit | md5)
		if [ "$NEW_MD5" != "$CURRENT_MD5" ] ; then
			restart_unit $unit
		else
			echo "INFO: $unit is unchanged."
		fi
	done
}

function start_all_inactive_units() {
        for unit in $(list_all_inactive_unit_files $1); do
		fleetctl destroy $unit
		start_unit $unit
	done
}

function list_all_units() {
        pattern=$(echo $1 | sed -e 's/@.service$/@[0-9][0-9]*.service/g')
	fleetctl list-units -fields=unit | egrep -e "$pattern"
}

function restart_all_active_units() {
        for unit in $(list_all_active_units $1); do
		restart_unit $unit
	done
}

if [ $# -eq 1 -a -f "$1" ] ; then
	update_template $1
	restart_all_active_units $1
	start_all_inactive_units $1
fi

