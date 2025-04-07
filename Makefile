# Compiler and Flags
CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++17

# Directories
BUILD_DIR = build
SERVER_DIR = server
SHORTENER_DIR = shortener
DB_DIR = db
DB_LIB_DIR = $(DB_DIR)/libs

SERVER_BUILD = $(BUILD_DIR)/server
SHORTENER_BUILD = $(BUILD_DIR)/shortener

# Server files
SERVER_SRC = $(SERVER_DIR)/http_server.cpp $(SERVER_DIR)/test.cpp
SERVER_OBJ = $(patsubst $(SERVER_DIR)/%.cpp, $(SERVER_BUILD)/%.o, $(SERVER_SRC))
SERVER_TARGET = server_app

# Shortener files
SHORTENER_SRC = $(SHORTENER_DIR)/url_shortener.cpp $(SHORTENER_DIR)/test.cpp
SHORTENER_OBJ = $(patsubst $(SHORTENER_DIR)/%.cpp, $(SHORTENER_BUILD)/%.o, $(SHORTENER_SRC))
SHORTENER_TARGET = shortener_app

# DB files
DB_SRC = $(DB_DIR)/db.cpp
DB_TARGET = db_app
SQLITE_STATIC_LIB = $(DB_LIB_DIR)/libsqlite3.a
SQLITE_INCLUDE = -I$(DB_LIB_DIR)

.PHONY: all server shortener db clean

# Default target
all: server shortener db

# Server target
server: $(SERVER_OBJ)
	$(CXX) $(CXXFLAGS) -o $(SERVER_TARGET) $(SERVER_OBJ)

# Shortener target
shortener: $(SHORTENER_OBJ)
	$(CXX) $(CXXFLAGS) -o $(SHORTENER_TARGET) $(SHORTENER_OBJ)

# DB target (outputs directly in root dir)
db:
	$(CXX) $(CXXFLAGS) $(SQLITE_INCLUDE) $(DB_SRC) $(SQLITE_STATIC_LIB) -o $(DB_TARGET)

# Compile .cpp files into .o files
$(SERVER_BUILD)/%.o: $(SERVER_DIR)/%.cpp | $(SERVER_BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(SHORTENER_BUILD)/%.o: $(SHORTENER_DIR)/%.cpp | $(SHORTENER_BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Create build directories
$(SERVER_BUILD) $(SHORTENER_BUILD):
	mkdir -p $@

# Clean target
clean:
	rm -rf $(SERVER_BUILD) $(SHORTENER_BUILD)
	rm -f $(SERVER_TARGET) $(SHORTENER_TARGET) $(DB_TARGET)
