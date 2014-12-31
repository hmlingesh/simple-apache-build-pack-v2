#!/usr/bin/env bash

echo "Starting.." >&2
echo "Starting.."
if [[ ! ( -f $1/index.html || -f $1/index.htm || -f $1/Default.htm ) ]]
then
echo "No" && exit 1
else
echo "Static" && exit 0
fi
