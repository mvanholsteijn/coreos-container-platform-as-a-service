#!/bin/bash
echo INFO: submitting fleet unit files
fleetctl submit mnt-data.mount mysql@.service

echo INFO: loading fleet unit files
fleetctl load mnt-data.mount mysql@.service

fleetctl start mysql@prod.service
