#!/bin/bash

PID=0

haproxy_quit() {
  echo "Received SIGINT/SIGQUIT, Exiting ..."
  exit 0
}

haproxy_reload() {
  echo "Reloading HAProxy Configuration"
  haproxy -D -f /usr/local/etc/templates/haproxy/haproxy.conf -p /var/run/haproxy.pid -st $(cat /var/run/haproxy.pid)
}

haproxy_stats() {
  echo "Dumping Stats"
  kill -HUP $(cat /var/run/haproxy.pid)
}

trap 'kill ${!}; haproxy_reload' SIGUSR1
trap 'kill ${!}; haproxy_stats' SIGHUP
trap 'kill ${!}; haproxy_quit' SIGINT SIGQUIT SIGTERM

echo "Starting HAProxy"
haproxy -D -f /usr/local/etc/templates/haproxy/haproxy.conf -p /var/run/haproxy.pid &
PID=${!}

while true
do
  tail -f /dev/null & wait ${!}
done

