#!/bin/bash
set -e

while true; do
    rsync -a --delete /source/ /backup/
    sleep 60
done
