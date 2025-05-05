#include "http_server.hpp"

HTTPServer::HTTPServer(int port, const std::string &dbPath) : db(dbPath){
    addr_len = sizeof(address);
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1){
        throw std::runtime_error("Socket creation failed!");
    }
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(port);
    if (bind(server_fd, (struct sockaddr*)&address, sizeof(address)) < 0){
        throw std::runtime_error("Binding failed!");
    }
    if (listen(server_fd, 10) < 0){
        throw std::runtime_error("Listening failed!");
    }
    std::cout << "Server running on port " << port << "...\n";
}

HTTPServer::~HTTPServer(){
    close(server_fd);
}

void HTTPServer::run(){
    while (true){
        int client_fd = accept(server_fd, (struct sockaddr*)&address, &addr_len);
        if (client_fd < 0){
            std::cerr << "Failed to accept connection!" << std::endl;
            continue;
        }
        handleClient(client_fd);
    }
}

void HTTPServer::handleClient(int client_fd){
    char buffer[BUFFER_SIZE] = {0};
    read(client_fd, buffer, BUFFER_SIZE);
    std::cout << "Request:\n" << buffer << std::endl;
    std::string response = handleRequest(buffer);
    std::cout << "Response:\n" << response << std::endl;
    send(client_fd, response.c_str(), response.length(), 0);
    close(client_fd);
}

std::string HTTPServer::extractPath(const std::string &request){
    size_t start = request.find("GET ");
    if (start == std::string::npos) return "HTTP/1.1 400 Bad Request\r\n...";
    start += 4;
    size_t end = request.find(" ", start);
    if (end == std::string::npos) return "HTTP/1.1 400 Bad Request\r\n...";
    std::string path = request.substr(start, end - start);
    if (path.size() > 1 && path[0] == '/') {
        path = path.substr(1);
    }
    return path;
}

std::string HTTPServer::handleFavicon(){
    return "HTTP/1.1 200 OK\r\n"
               "Content-Type: image/x-icon\r\n"
               "Content-Length: 0\r\n"
               "\r\n";
}

std::string HTTPServer::generateResponse(const std::string &path){
    if (!path.empty() && std::all_of(path.begin(), path.end(), ::isdigit)) {
        size_t code = std::stoi(path);
        std::string url = db.fetchURL(code);
        if (url.find("http://") != 0 && url.find("https://") != 0) {
            return "HTTP/1.1 400 Bad Request\r\n"
                   "Content-Type: text/plain\r\n"
                   "Content-Length: 20\r\n"
                   "\r\n"
                   "URL is not absolute.(URL starts with http or https)";
        }
        std::stringstream response;
        response << "HTTP/1.1 307 Temporary Redirect\r\n"
                 << "Location: " << url << "\r\n"
                 << "Content-Length: 0\r\n"
                 << "\r\n";
        return response.str();
    }

    return "HTTP/1.1 400 Bad Request\r\n"
           "Content-Type: text/plain\r\n"
           "Content-Length: 16\r\n"
           "\r\n"
           "Invalid Request!";
}

std::string HTTPServer::handleRequest(const std::string& request){
    std::string path = extractPath(request);    
    if (path == "favicon.ico") {
        return handleFavicon();
    }
    return generateResponse(path);
}