# Compiler and Flags
CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++17 -pthread
LDFLAGS = -lsqlite3

# Directories
BUILD_DIR = build
DB_DIR = db
SHORTENER_DIR = shortener
SERVER_DIR = server
FRONTEND_DIR = frontend

# Crow and Boost paths for frontend
CROW_INCLUDE = -I$(FRONTEND_DIR)/lib/Crow/include
BOOST_LIBS = -lboost_system -lpthread

# ==== APP (Console Main App) ====
APP_SRCS = app.cpp \
           $(DB_DIR)/db.cpp \
           $(SHORTENER_DIR)/url_shortener.cpp \
           $(SERVER_DIR)/http_server.cpp

APP_OBJS = $(patsubst %.cpp, $(BUILD_DIR)/%.o, $(notdir $(APP_SRCS)))
TARGET = url_app

# ==== SERVER TEST ====
SERVER_SRCS = $(SERVER_DIR)/http_server.cpp \
              $(SERVER_DIR)/server_test.cpp \
              $(DB_DIR)/db.cpp

SERVER_OBJS = $(patsubst %.cpp, $(BUILD_DIR)/%.o, $(notdir $(SERVER_SRCS)))
SERVER_TARGET = server_app

# ==== FRONTEND (Crow-based) ====
FRONTEND_SRCS = $(FRONTEND_DIR)/main.cpp \
                $(DB_DIR)/db.cpp \
                $(SHORTENER_DIR)/url_shortener.cpp

FRONTEND_OBJS = $(patsubst %.cpp, $(BUILD_DIR)/%.o, $(notdir $(FRONTEND_SRCS)))
FRONTEND_TARGET = frontend_app

# ==== PHONY TARGETS ====
.PHONY: all clean server frontend

# ==== DEFAULT ====
all: $(TARGET)

# ==== BUILD RULES ====
$(TARGET): $(APP_OBJS)
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS)

server: $(SERVER_OBJS)
	$(CXX) $(CXXFLAGS) $^ -o $(SERVER_TARGET) $(LDFLAGS)

frontend: $(FRONTEND_OBJS)
	$(CXX) $(CXXFLAGS) $(CROW_INCLUDE) $^ -o $(FRONTEND_TARGET) $(LDFLAGS) $(BOOST_LIBS)

# ==== OBJECT FILE RULES ====
$(BUILD_DIR)/%.o: $(DB_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SHORTENER_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(SERVER_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(BUILD_DIR)/%.o: $(FRONTEND_DIR)/%.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) $(CROW_INCLUDE) -c $< -o $@

$(BUILD_DIR)/%.o: %.cpp | $(BUILD_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# ==== BUILD DIR CREATION ====
$(BUILD_DIR):
	mkdir -p $@

# ==== CLEAN ====
clean:
	rm -rf $(BUILD_DIR) $(TARGET) $(SERVER_TARGET) $(FRONTEND_TARGET)
