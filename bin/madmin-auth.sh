#!/bin/sh

protocol=http
host=localhost
port=3000

if [ $# -ne 2 ]; then
  echo "Usage: $(basename $0) email password"
  exit 1
fi

name="${1%@*}"
domain="${1#*@}"
pass="$2"
url="$protocol://$host:$port/login.json"

status=$(curl -i -s -S --data-urlencode "name=$name" --data-urlencode "domain=$domain" --data-urlencode "password=$pass" $url | awk '/^HTTP/ {print $2}')

case $status in 
  3*|2*)
    echo 'ok'
    exit 0
    ;;
  4*|5*)
    echo 'failed'
    exit 1
    ;;
  *)
    echo $status
    exit 1
esac
