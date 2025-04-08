#include "db/db.hpp"
#include "shortener/url_shortener.hpp"
#include "server/http_server.hpp"
#include <iostream>
#include <thread>

int main(){
    URLShortener shortener;
    Database db("urls.db");
    db.createTable();

    try {
        HTTPServer server(PORT, "urls.db");
        std::thread serverThread([&]() {
            server.run();
        });

        std::string url;
        std::cout << "URL SHORTENER" << std::endl; // maybe ascii style later
        std::cout << "Enter the url to shorten: ";
        getline(std::cin, url);
        size_t code = shortener.hashURL(url);
        if(!db.storeURL(url, code)){
            std::cerr << "Error: url not stored in database" << std::endl;
        }
        std::cout << "Shortened url: http://localhost:8080/" << code << std::endl; 
        serverThread.join();
    } 
    catch (const std::exception& e){
        std::cerr << e.what() << std::endl;
        return -1;
    }
    return 0;
}