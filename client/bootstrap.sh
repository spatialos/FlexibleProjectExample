#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "hostname argument not set"
  read -p "Press any key to continue..."
  exit 1
fi
if [ -z "$2" ]; then
  echo "pit argument not set"
  read -p "Press any key to continue..."
  exit 1
fi
if [ -z "$3" ]; then
  echo "lt argument not set"
  read -p "Press any key to continue..."
  exit 1
fi

HOSTNAME=$1
PIT=$2
LT=$3

rm -rf run_client.sh
echo "#!/usr/bin/env bash

cd '$PWD'
mono --arch=64 Client.exe cloud ${HOSTNAME} ${PIT} ${LT}
" >> run_client.sh

chmod 777 run_client.sh
open -a Terminal.app run_client.sh