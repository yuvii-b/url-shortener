#pragma once

#include <iostream>
#include <algorithm>
#include <sstream>
#include <string>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>

#define PORT 8080
#define BUFFER_SIZE 4096

class HTTPServer {
private:
    int server_fd;
    struct sockaddr_in address;
    socklen_t addr_len;

    void handleClient(int client_fd);
    std::string handleRequest(const std::string &request);
    std::string extractPath(const std::string &request);
    std::string handleFavicon();
    std::string generateResponse(const std::string &path);

public:
    HTTPServer(int port);
    ~HTTPServer();
    void run();
};