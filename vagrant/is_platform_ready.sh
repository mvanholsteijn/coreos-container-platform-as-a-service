#!/bin/bash

function count_running() {
	for i in 1 2 3 ; do
		vagrant ssh -c "systemctl | grep consul | awk '{print \$4;}' " core-0$i 2>/dev/null
	done | \
	wc -l | \
	sed -e 's/[ \t]*//g'
} 

EXPECT=$(expr 3 \* $(ls -1 ../fleet-units/platform/*.service | wc -l))
RUNNING=$(count_running)
while [ $RUNNING -ne $EXPECT ] ; do
	echo INFO: $RUNNING out of $EXPECT processes running.. Waiting ...
	sleep 2
	RUNNING=$(count_running)
done
echo INFO: platform ready\!

