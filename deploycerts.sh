#!/bin/bash

set -e

main () {
  seq $2 | xargs -n1 -I {} ./deploycert.sh $1{}
}

main $@
