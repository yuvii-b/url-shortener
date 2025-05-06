# URL Shortener

A lightweight, terminal-based and web-based(using Crow-CPP) URL shortening service built with C++ and a simple HTTP server. It allows users to shorten long URLs into concise numeric codes and redirects incoming HTTP requests to the original URL.

## Features

- 🧠 Hash-based URL shortening
- 🌐 HTTP server to redirect shortened URLs
- 💾 SQLite-based database for persistent storage
- 🖥️ Console UI for URL input and management
- 🖥️ Web based UI for user friendly environmnet
- 🐧 Compatible with Linux via WSL (Windows Subsystem for Linux)

## How It Works

1. User enters a URL in the console app.
2. The app stores a hash of the URL in a SQLite database.
3. An HTTP server listens on `localhost:8080` and redirects requests like `http://localhost:8080/123456` to the original URL.

## Requirements

- C++17 or later
- `make`
- `sqlite3`
- Crow-cpp library
- Linux or WSL on Windows

## Installation

Follow the steps below to set up the project:

1. **Clone this repository**:

   ```bash
   git clone https://github.com/yuvii-b/url-shortener.git
   cd url-shortener
   ```
2. **Create the required directory structure**:

    ```bash
    mkdir -p frontend/lib
    cd frontend/lib
    ```
3. **Clone the Crow C++ library**:

    ```bash
    git clone https://github.com/CrowCpp/crow.git 
    ```
4. **Make sure you have the following dependencies installed**:
    - g++ 
    - make
    - sqlite3
    ```bash 
    sudo apt update && sudo apt install -y g++ make sqlite3
    ``` 

## Running the application

1. CLI TOOL:

    Follow these steps to build and run the URL Shortener application:

    1. **Build the server application**:

    ```bash
    make server
    ```
    2. **Build the main application**:
        ```bash
        make
        ```
    3. **Make the launcher script executable**:
        ```bash
        chmod +x run.sh
        ```
    4. **Run the application**: 
        ```bash
        ./run.sh
        ```
    The `run.sh` script will start both the server and the URL app, and it will monitor the server for crashes. If the server or app stops unexpectedly, both processes will be shut down.

    5. **After finishing, Clean everything**:
        ```bash
        make clean
        ```
            