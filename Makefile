CXX = clang++
# Lua 5.5.0 installed via Homebrew to Cellar
LUA_CELLAR = /usr/local/Cellar/lua/5.5.0
LUA_INCLUDE = $(LUA_CELLAR)/include/lua
LUA_LIB = $(LUA_CELLAR)/lib

CXXFLAGS = -std=c++17 -Wall -O3 -I$(LUA_INCLUDE)
LDFLAGS = -L$(LUA_LIB) -llua5.5 -lcurl

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
