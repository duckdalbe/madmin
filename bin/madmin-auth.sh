#!/bin/sh

protocol=http
host=localhost
port=3000

if [ $# -ne 2 ]; then
  echo "Usage: $(basename $0) email password"
  exit 1
fi

urlescape() {
  echo $(perl -MURI::Escape -e "print uri_escape('$1')")
}
name=$(urlescape "${1%@*}")
domain=$(urlescape "${1#*@}")
pass=$(urlescape "$2")

# TODO: url-encode params
url="$protocol://$host:$port/login.json?name=$name&domain=$domain&password=$pass"
status=$(curl -I -s -S $url | grep ^HTTP | tail -n 1 | awk '{print $2}')

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
