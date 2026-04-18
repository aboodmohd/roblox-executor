CXX = clang++
# Get Lua include and lib paths from brew
LUA_PREFIX = $(shell brew --prefix lua)
# Include both base and versioned subdirectory
LUA_INCLUDE = -I$(LUA_PREFIX)/include -I$(LUA_PREFIX)/include/lua5.4 -I$(LUA_PREFIX)/include/lua

CXXFLAGS = -std=c++17 -Wall -O3 $(LUA_INCLUDE)
LDFLAGS = -L$(LUA_PREFIX)/lib -llua -lcurl

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
