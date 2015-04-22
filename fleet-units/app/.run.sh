#!/bin/bash
for unit in mnt-data.mount app-redis.service app-hellodb@.service; do
	echo INFO: submitting unit file $unit
	fleetctl submit $unit
done

for unit in mnt-data.mount app-redis.service ; do
	echo INFO: loading fleet unit file $unit
	fleetctl load $unit
done
echo INFO starting app-redis..
fleetctl start app-redis.service

for i in 1 2 3 ; do
	echo INFO starting app-hello@$i..
	fleetctl start app-hellodb@$i.service
done
