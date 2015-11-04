# CoreOS Container platform

This is the vagrant setup for the CoreOS platform.


## To start
To start it, install Vagrant and VirtualBox on your machine and type:

```
$ vagrant up
$ . ./setenv
```

it starts a 3 machines with 1 Virtual CPUs and 1Gb of RAM. If this is not sufficient for your
application, modify the required amount of memory per machine or increase the number of machines
in config.rb. 

## wait for Initialization
Wait for the platform to be ready. When you type:

```
$ vagrant ssh core-01 -- -t watch fleetctl list-units
```

you should see the following output

```
UNIT                                    MACHINE                         ACTIVE  SUB
consul-http-router.service              6e1a9adb.../172.17.8.102        active  running
consul-http-router.service              9b969332.../172.17.8.101        active  running
consul-http-router.service              dd9eb383.../172.17.8.103        active  running
consul-server-registrator.service       6e1a9adb.../172.17.8.102        active  running
consul-server-registrator.service       9b969332.../172.17.8.101        active  running
consul-server-registrator.service       dd9eb383.../172.17.8.103        active  running
consul-server.service                   6e1a9adb.../172.17.8.102        active  running
consul-server.service                   9b969332.../172.17.8.101        active  running
consul-server.service                   dd9eb383.../172.17.8.103        active  running
```


## Connect to the Docker Deamon
to verify proper operation, type:
```
$ docker ps
```

## View your http services
To view your http services, goto:

```
$ open $HTTP_ROUTER
```

Via this page, you can go to all the HTTP services advertised in Consul.

