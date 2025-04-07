extern "C" {
    #include "libs/sqlite3.h"
}

#include <iostream>

int main() {
    sqlite3* db;
    if (sqlite3_open("test.db", &db)) {
        std::cerr << "Can't open DB: " << sqlite3_errmsg(db) << std::endl;
        return 1;
    }
    std::cout << "Opened database successfully ✅\n";
    sqlite3_close(db);
    return 0;
}
