#!/bin/bash

set -e

main () {
  gencerts $1
  chmod 0644 coreos-key.pem
  scp ca.pem coreos-key.pem coreos.pem core@`get_public_ip $1`:
  rm ca.pem coreos-key.pem coreos.pem
}

gencerts () {
  cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=ca-config.json -profile=client-server <(output_ssl_config $1) | cfssl_generate
}

cfssl_generate () {
  cfssljson -bare coreos
}

output_ssl_config () {
  doctl -f json d f $1 | jq '.networks.v4' | jq -r ".[] | select(.type == \"private\") | setpath([\"name\"]; \"$1\")" | jq -f coreos-default.json
}

get_public_ip () {
  doctl -f json d f $1 | jq '.networks.v4' | jq -r '.[] | select(.type == "public") | .ip_address'
}

main $@
