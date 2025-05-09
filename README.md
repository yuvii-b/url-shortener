# URL Shortener

A lightweight, terminal-based and web-based(using Crow-CPP) URL shortening service built with C++ and a simple HTTP server. It allows users to shorten long URLs into concise numeric codes and redirects incoming HTTP requests to the original URL.

## Features

- 🧠 Hash-based URL shortening
- 🌐 HTTP server to redirect shortened URLs
- 💾 SQLite-based database for persistent storage
- 🖥️ Console UI for URL input and management
- 🖥️ Web based UI for user friendly environment
- 🐧 Compatible with Linux via WSL (Windows Subsystem for Linux)

## How It Works

1. User enters a long URL via CLI or web UI.
2. The URL is hashed and stored in a SQLite database.
3. An HTTP server listens on `localhost:8080`.
4. Requests to `http://localhost:8080/<shortcode>` are redirected to the original URL.

## Requirements

- C++17 or later
- `make`
- `sqlite3`
- Crow-cpp library
- Linux or WSL (Windows Subsystem for Linux)

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

    Follow these steps to build and run the URL Shortener command line application:

    1. **Build the backend server application**:

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

    5. **After running, Clean everything**:
        ```bash
        make clean
        ```
2. FRONTEND TOOL (WEB UI):

    Follow these steps to build and run the URL Shortener web-based application:

     1. **Build the backend server application**:

    ```bash
    make server
    ```

    2. **Build the frontend server application**:
        ```bash
        make frontend
        ```
    3. **Run both servers (in separate terminals) for capturing logs**
        ```bash
        ./server_app
        ./frontend_app
        ```
    4. **Open the webpage in browser**
        Navigate to `index.html` and hit 'go live' in vscode(if installed) or simply open the file in any browser
    5. **After running, Clean everything**:
        ```bash
        make clean
        ``` 

### License

This project is licensed under the [MIT License](LICENSE).

## 👥 Contributors

- **Yuvaraj B** – [@yuvii-b](https://github.com/yuvii-b)
- **Aravinth K** – [@bored-arvi](https://github.com/bored-arvi)

> Want to contribute? Refer [contribution guidelines](CONTRIBUTING.md)!