#ifndef URL_SHORTENER_HPP
#define URL_SHORTENER_HPP

#include <unordered_map>
#include <string>

class URLShortener{
    private:
        std::unordered_map<int, std::string> hashMap;
        const size_t PRIME = 1000003;
    public:
        size_t hashURL(const std::string &url);
        size_t shortenURL(const std::string &url);
        std::string getURL(size_t value); 
};

#endif