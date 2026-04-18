CXX = clang++

# Use pkg-config to find Lua and Curl
LUA_CFLAGS = $(shell pkg-config --cflags lua 2>/dev/null || pkg-config --cflags lua5.4 2>/dev/null || pkg-config --cflags lua5.3 2>/dev/null)
LUA_LIBS = $(shell pkg-config --libs lua 2>/dev/null || pkg-config --libs lua5.4 2>/dev/null || pkg-config --libs lua5.3 2>/dev/null)
CURL_CFLAGS = $(shell pkg-config --cflags libcurl)
CURL_LIBS = $(shell pkg-config --libs libcurl)

CXXFLAGS = -std=c++17 -Wall -O3 $(LUA_CFLAGS) $(CURL_CFLAGS)
LDFLAGS = $(LUA_LIBS) $(CURL_LIBS)

SRC = src/gui.mm
OBJ = $(SRC:.mm=.o)
TARGET = RobloxExecutor

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CXX) $(OBJ) -o $(TARGET) $(LDFLAGS) -framework Cocoa

%.o: %.mm
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(TARGET)
