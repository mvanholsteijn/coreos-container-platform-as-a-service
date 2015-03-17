#!/bin/bash
fleetctl submit app-haproxy@.service
fleetctl submit app-hellodb@.service
fleetctl submit app-redis.service
fleetctl start app-redis.service
fleetctl start app-hellodb@1.service
fleetctl start app-hellodb@2.service
fleetctl start app-hellodb@3.service
NO_MACHINES=$(fleetctl list-machines  | grep -v MACHINE | wc -l | sed 's/[ \t]*//g')
while [ $NO_MACHINES -gt 0 ] ; do
	eval fleetctl start app-haproxy@${NO_MACHINES}.service
	NO_MACHINES=$(($NO_MACHINES - 1))
done
