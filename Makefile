# Compiler and Flags
CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++17
DB_FLAG = -lsqlite3

# Directories
BUILD_DIR = build
SERVER_DIR = server
SHORTENER_DIR = shortener
DB_DIR = db

# Source files
SERVER_SRC = $(SERVER_DIR)/http_server.cpp $(SERVER_DIR)/test_server.cpp
SHORTENER_SRC = $(SHORTENER_DIR)/url_shortener.cpp $(SHORTENER_DIR)/test_shortener.cpp
DB_SRC = $(DB_DIR)/db.cpp $(DB_DIR)/test_db.cpp $(SHORTENER_DIR)/url_shortener.cpp

# Object files (flattened to build/)
SERVER_OBJ = $(patsubst %.cpp, $(BUILD_DIR)/%.o, $(notdir $(SERVER_SRC)))
SHORTENER_OBJ = $(patsubst %.cpp, $(BUILD_DIR)/%.o, $(notdir $(SHORTENER_SRC)))
DB_OBJ = $(patsubst %.cpp, $(BUILD_DIR)/%.o, $(notdir $(DB_SRC)))

# Targets
SERVER_TARGET = server_app
SHORTENER_TARGET = shortener_app
DB_TARGET = dbase

.PHONY: all server shortener db clean

all: server shortener db

# Server target
server: $(SERVER_OBJ)
	$(CXX) $(CXXFLAGS) -o $(SERVER_TARGET) $(SERVER_OBJ)

# Shortener target
shortener: $(SHORTENER_OBJ)
	$(CXX) $(CXXFLAGS) -o $(SHORTENER_TARGET) $(SHORTENER_OBJ) $(DB_FLAG)

# DB target
db: $(DB_OBJ)
	$(CXX) $(CXXFLAGS) -o $(DB_TARGET) $(DB_OBJ) $(DB_FLAG)

# Rules to build .o files from each folder
$(BUILD_DIR)/%.o: $(SERVER_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -I$(SERVER_DIR) -I$(SHORTENER_DIR) -I$(DB_DIR) -c $< -o $@

$(BUILD_DIR)/%.o: $(SHORTENER_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -I$(SHORTENER_DIR) -I$(DB_DIR) -c $< -o $@

$(BUILD_DIR)/%.o: $(DB_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -I$(DB_DIR) -I$(SHORTENER_DIR) -c $< -o $@

# Create build directory if it doesn't exist
$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

# Clean
clean:
	rm -rf $(BUILD_DIR) *.o $(SERVER_TARGET) $(SHORTENER_TARGET) $(DB_TARGET)
