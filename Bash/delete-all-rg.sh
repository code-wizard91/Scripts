#!/usr/bin/ bash
echo "Deleting all Resource-Groups without Lock"
for i in `az group list -o tsv --query [].name`; do if [ "$(az lock list -g $i -o tsv --query [].name)" ]; then echo "$i have a lock"; else az group delete -n $i -y --no-wait; fi; done