#pragma once

#include "libs/sqlite3.h"
#include <string>
#include <iostream>

class Database{
    private:
        sqlite3* db;
        
    public:
        Database(){}
        Database(const std::string &path);
        ~Database();

        void createTable();
        std::string fetchURL(size_t code);
        bool storeURL(const std::string &url, size_t code);
};