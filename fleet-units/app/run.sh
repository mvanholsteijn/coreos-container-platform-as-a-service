#!/bin/bash
fleetctl submit app-hellodb@.service
fleetctl submit app-redis.service
fleetctl start app-redis.service
fleetctl start app-hellodb@1.service
fleetctl start app-hellodb@2.service
fleetctl start app-hellodb@3.service
