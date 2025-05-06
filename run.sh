#!/bin/bash

SERVER_CMD="./server_app"
APP_CMD="./url_app"
SERVER_PORT=8080

echo "[INFO] Starting the server..."
$SERVER_CMD &
SERVER_PID=$!

echo "[INFO] Waiting for the server to be available on port $SERVER_PORT..."

for i in {1..100}; do
    if nc -z localhost $SERVER_PORT; then
        echo "[INFO] Server is up on port $SERVER_PORT."
        break
    fi
    sleep 0.1
done

if ! nc -z localhost $SERVER_PORT; then
    echo "[ERROR] Server did not start correctly on port $SERVER_PORT."
    kill $SERVER_PID 2>/dev/null
    exit 1
fi

echo "[INFO] Starting the URL shortening app..."
$APP_CMD

echo "[INFO] URL shortening app has exited. Shutting down the server."

kill $SERVER_PID 2>/dev/null
wait $SERVER_PID 2>/dev/null

echo "[INFO] Server has been shut down."

exit 0