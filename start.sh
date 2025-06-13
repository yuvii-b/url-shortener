#!/bin/sh

cleanup(){
    echo "Cleaning up"
    make clean
    exit 0
}

trap cleanup INT TERM

./server_app &
HTTP_PID = $!
./frontend_app &
CROW_PID = $!

exec /bin/sh

wait $HTTP_PID $CROW_PID

cleanup