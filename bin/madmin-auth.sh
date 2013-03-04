#!/usr/bin/env zsh

protocol=http
host=localhost
port=3000

if [ $# -ne 0 ]; then
  echo "Usage: $(basename $0) 3< 'username\0password\0'"
  exit 2
fi

exec 3<&0
read -t 1 -r user pass

name="${user%@*}"
domain="${user#*@}"
url="$protocol://$host:$port/login.json"

response=$(curl -i -s -S --data-urlencode "name=$name" --data-urlencode "domain=$domain" --data-urlencode "password=$pass" $url | awk '/^HTTP/ {print $2}')

case $response in
  3*|2*)
    # ok
    exit 0
    ;;
  4*|5*)
    # fail
    exit 1
    ;;
  *)
    # something unknown is wrong, temp error
    exit 111
esac
