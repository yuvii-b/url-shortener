#include "url_shortener.hpp"

size_t URLShortener::hashURL(const std::string &url){
    const size_t PRIME1 = 14695981039346656037ULL;
    const size_t PRIME2 = 1099511628211ULL;

    size_t hashValue = PRIME1;
    for(char c : url){
        hashValue ^= c;
        hashValue *= PRIME2;
        hashValue ^= (hashValue >> 27);
    }
    
    return hashValue % PRIME;
}

size_t URLShortener::shortenURL(const std::string &url){
    size_t value = hashURL(url);
    hashMap[value] = url;
    return value;
}

std::string URLShortener::getURL(size_t value){
    if(hashMap.find(value) != hashMap.end()){
        return hashMap[value];
    }
    return "URL Not Found!";
}