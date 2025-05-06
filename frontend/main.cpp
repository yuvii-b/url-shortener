#include "crow.h"
#include "../shortener/url_shortener.hpp"
#include "../db/db.hpp"
#include <filesystem>
#include <fstream>
#include <sstream>

std::string load_file(const std::string &path) {
    std::ifstream file(path);
    std::stringstream buffer;
    buffer << file.rdbuf();
    return buffer.str();
}

std::string generate_short_url(const std::string &long_url){
	URLShortener shortener;
	Database db("urls.db");
	size_t code = shortener.hashURL(long_url);
	if(!db.storeURL(long_url, code)) return "Error";
	return "http://localhost:8080/" + std::to_string(code);
}

int main(){
	crow::SimpleApp app;

	CROW_ROUTE(app, "/")([](){
		return crow::response(load_file("frontend/templates/index.html"));
	});

	CROW_ROUTE(app, "/shorten").methods("POST"_method)([](const crow::request& req) {
		std::string body = req.body;
		size_t long_url_pos = body.find("long=");
		
		if (long_url_pos == std::string::npos){
			return crow::response(400, "Missing long URL");
		}
		long_url_pos += 5;
		std::string long_url = body.substr(long_url_pos);
		if(long_url.empty()){
			return crow::response(400, "Long URL cannot be empty");
		}
		std::string decoded_url;
		for (size_t i = 0; i < long_url.length(); ++i) {
			if (long_url[i] == '%') {
				int hex_value;
				sscanf(long_url.substr(i + 1, 2).c_str(), "%x", &hex_value);
				decoded_url.push_back(static_cast<char>(hex_value));
				i += 2; 
			} else if (long_url[i] == '+') {
				decoded_url.push_back(' ');
			} else {
				decoded_url.push_back(long_url[i]);
			}
		}
		std::string short_url = generate_short_url(decoded_url);

		crow::response res(short_url);
		res.add_header("Access-Control-Allow-Origin", "*"); // to prevent cors error
		return res;
    });

	app.port(4040).multithreaded().run();
	return 0;
}
