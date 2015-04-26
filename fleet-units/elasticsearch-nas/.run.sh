#!/bin/bash
for unit in mnt-data.mount es-nas@.service ; do
	echo INFO: submitting unit file $unit
	fleetctl submit $unit
done

for unit in mnt-data.mount es-nas@{1..3}.service ; do
	echo INFO: loading fleet unit file $unit
	fleetctl load $unit
done
echo INFO starting ElasticSearch cluster nodes..
for i in 1 2 3 ; do
	echo INFO starting es-nas@$i..
	fleetctl start es-nas@$i.service
done
