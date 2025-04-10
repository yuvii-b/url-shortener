#include "db.hpp"

Database::Database(const std::string &path){
    if (sqlite3_open(path.c_str(), &db)) {
        std::cerr << "Failed to open DB: " << sqlite3_errmsg(db) << std::endl;
        db = nullptr;
    }
}

Database::~Database(){
    if(db) sqlite3_close(db);
}

void Database::createTable(){
    const char *query = R"(
        CREATE TABLE IF NOT EXISTS urls(url TEXT NOT NULL UNIQUE, code INTEGER PRIMARY KEY NOT NULL);
    )";
    char *err = nullptr;
    if(sqlite3_exec(db, query, nullptr, nullptr, &err) != SQLITE_OK){
        std::cerr << "Table creation failed: " << err << std::endl;
        sqlite3_free(err);
    }
}

std::string Database::fetchURL(size_t code){
    const char* sql = "SELECT url FROM urls WHERE code = ?;";
    sqlite3_stmt* stmt;
    std::string URL = "(not found)";

    if (sqlite3_prepare_v2(db, sql, -1, &stmt, nullptr) == SQLITE_OK){
        sqlite3_bind_int(stmt, 1, code);
        if (sqlite3_step(stmt) == SQLITE_ROW){
            URL = reinterpret_cast<const char*>(sqlite3_column_text(stmt, 0));
        }
    } 
    else{
        std::cerr << "⚠️ Query failed: " << sqlite3_errmsg(db) << std::endl;
    }
    sqlite3_finalize(stmt);
    return URL;
}

bool Database::storeURL(const std::string &url, size_t code){
    const char* sql = "INSERT INTO urls (url, code) VALUES (?, ?);";
    sqlite3_stmt* stmt;

    if (sqlite3_prepare_v2(db, sql, -1, &stmt, nullptr) == SQLITE_OK){
        sqlite3_bind_text(stmt, 1, url.c_str(), -1, SQLITE_STATIC);
        sqlite3_bind_int(stmt, 2, code);
        if (sqlite3_step(stmt) == SQLITE_DONE){
            sqlite3_finalize(stmt);
            return true;
        }
        else if(sqlite3_step(stmt) == SQLITE_CONSTRAINT){
            std::cerr << "⚠️ URL or Code already exists in the database." << std::endl;
            return true;
        }
        else{
            std::cerr << "⚠️ Insert failed: " << sqlite3_errmsg(db) << std::endl;
        }
    }
    else{
        std::cerr << "⚠️ Prepare failed: " << sqlite3_errmsg(db) << std::endl;
    }
    sqlite3_finalize(stmt);
    return false;
}