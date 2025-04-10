# Compiler and Flags
CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++17 -pthread
LDFLAGS = -lsqlite3

# Directories
BUILD_DIR = build
DB_DIR = db
SHORTENER_DIR = shortener
SERVER_DIR = server

# Final App
APP_SRCS = app.cpp \
           $(DB_DIR)/db.cpp \
           $(SHORTENER_DIR)/url_shortener.cpp \
           $(SERVER_DIR)/http_server.cpp

APP_OBJS = $(patsubst %.cpp, $(BUILD_DIR)/%.o, $(notdir $(APP_SRCS)))
TARGET = url_app

# Server Module Test (standalone)
SERVER_SRCS = $(SERVER_DIR)/http_server.cpp $(SERVER_DIR)/server_test.cpp $(DB_DIR)/db.cpp
SERVER_OBJS = $(patsubst %.cpp, $(BUILD_DIR)/%.o, $(notdir $(SERVER_SRCS)))
SERVER_TARGET = server_app

.PHONY: all clean server

# Default: Build main app
all: $(TARGET)

$(TARGET): $(APP_OBJS)
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS)

# Server target with test main
server: $(SERVER_OBJS)
	$(CXX) $(CXXFLAGS) $^ -o $(SERVER_TARGET) $(LDFLAGS)

# Object build rules (flattened into build/)
$(BUILD_DIR)/%.o: $(DB_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SHORTENER_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SERVER_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: %.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# Ensure build dir exists
$(BUILD_DIR):
	mkdir -p $@

# Clean everything
clean:
	rm -rf $(BUILD_DIR) $(TARGET) $(SERVER_TARGET)
