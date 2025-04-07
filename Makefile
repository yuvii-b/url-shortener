# Compiler and Flags
CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++17

# Directories
BUILD_DIR = build
SERVER_DIR = server
SHORTENER_DIR = shortener
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

.PHONY: all server shortener clean

# Default target (build everything)
all: server shortener

# Build the server application
server: $(SERVER_OBJ)
	$(CXX) $(CXXFLAGS) -o $(SERVER_TARGET) $(SERVER_OBJ)

# Build the shortener application
shortener: $(SHORTENER_OBJ)
	$(CXX) $(CXXFLAGS) -o $(SHORTENER_TARGET) $(SHORTENER_OBJ)

# Rule to compile .cpp files into .o files inside build/
$(SERVER_BUILD)/%.o: $(SERVER_DIR)/%.cpp | $(SERVER_BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(SHORTENER_BUILD)/%.o: $(SHORTENER_DIR)/%.cpp | $(SHORTENER_BUILD)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Ensure build/ subdirectories exist
$(SERVER_BUILD) $(SHORTENER_BUILD):
	mkdir -p $@

# Clean up generated files
clean:
	rm -rf $(SERVER_BUILD) $(SHORTENER_BUILD) $(SERVER_TARGET) $(SHORTENER_TARGET)
