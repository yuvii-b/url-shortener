#include "db/db.hpp"
#include "shortener/url_shortener.hpp"
#include "server/http_server.hpp"
#include <iostream>

int main(){
    HTTPServer server(PORT);
    Database db("urls.db");
    URLShortener shortener;

    return 0;
}