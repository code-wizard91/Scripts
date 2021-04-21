#!/usr/bin/ bash
echo "Deleting all empty Resource-Groups"
for i in `az group list -o tsv --query [].name`; do if [ "$(az resource list -g $i -o tsv)" ]; then echo "$i is not empty"; else az group delete -n $i -y --no-wait; fi; done