#!/bin/sh

cleanup(){
    echo "Cleaning up"
    make clean
    exit 0
}

trap cleanup INT TERM

./server_app &

./frontend_app &

cd frontend/templates
python3 -m http.server 5500 --bind 0.0.0.0 &
cd ..
cd ..

exec /bin/sh

wait $HTTP_PID $CROW_PID

cleanup