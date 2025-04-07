#include "url_shortener.hpp"
#include <iostream>

int main(){
    std::string url = "https://www.snapchat.com/web/4bc6fe78-2227-5fa4-a809-2427869094d5";
    URLShortener shortener;
    size_t value = shortener.shortenURL(url);
    std::cout << "url: " << url << std::endl << "code: " << value << std::endl;
    std::cout << shortener.getURL(878228);
    return 0;
}