#!/bin/bash

set -e

main () {
  ssh core@`get_ip $1` ${@:2}
}

get_ip () {
  doctl -f json d f $1 | jq -r '.networks.v4 | .[] | select(.type == "public") | .ip_address'
}

main $@
