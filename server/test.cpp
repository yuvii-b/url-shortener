#include "http_server.hpp"

int main(){
    try {
        HTTPServer server(PORT);
        server.run();
    } catch (const std::exception& e) {
        std::cerr << e.what() << std::endl;
        return -1;
    }
    return 0;
}
