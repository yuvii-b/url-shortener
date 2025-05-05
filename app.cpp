#include "db/db.hpp"
#include "shortener/url_shortener.hpp"
#include "server/http_server.hpp"
#include <iostream>

int main(){
    URLShortener shortener;
    Database db("urls.db");
    db.createTable();
    std::cout << R"(
             _   _ ____  _       ____  _   _  ___  ____ _____ _____ _   _ _____ ____
            | | | |  _ \| |     / ___|| | | |/ _ \|  _ \_   _| ____| \ | | ____|  _ \
            | | | | |_) | |     \___ \| |_| | | | | |_) || | |  _| |  \| |  _| | |_) |
            | |_| |  _ <| |___   ___) |  _  | |_| |  _ < | | | |___| |\  | |___|  _ <
             \___/|_| \_\_____| |____/|_| |_|\___/|_| \_\|_| |_____|_| \_|_____|_| \_\
    )" << std::endl;
    while(true){
        std::string url;
        std::cout << "Enter the url to shorten (or type ('exit') / (ctrl+D) to quit): ";
        if(!getline(std::cin, url)){
            std::cout << "(ctrl+D) Exititng URL Shortener..." << std::endl;
            break;
        }
        if(url.empty() || url == "exit"){
            std::cout << "Exiting URL Shortener..." << std::endl;
            break;
        }
        if (url.find("http://") != 0 && url.find("https://") != 0){
            std::cout << "Entered URL is not absolute.. Must begin with http or https.." << std::endl;
            break;
        }
        size_t code = shortener.hashURL(url);
        if(!db.storeURL(url, code)) return -1;
        std::cout << "Shortened url: http://localhost:8080/" << code << std::endl;
    }
    return 0;
}