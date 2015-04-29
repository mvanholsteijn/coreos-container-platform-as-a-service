#!/bin/bash
echo INFO: submitting fleet unit files
for unit in mnt-data.mount elasticsearch@.service ; do
	fleetctl submit $unit
done

echo INFO: loading fleet unit files
for unit in mnt-data.mount elasticsearch@{1..3}.service ; do
	fleetctl load $unit
done
echo INFO starting ElasticSearch cluster nodes..
fleetctl start elasticsearch@{1..3}.service
