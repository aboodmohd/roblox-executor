CXX = clang++
# Get Lua include and lib paths from brew
LUA_PREFIX = $(shell brew --prefix lua)
LUA_INCLUDE = $(LUA_PREFIX)/include
LUA_LIB = $(LUA_PREFIX)/lib

CXXFLAGS = -std=c++17 -Wall -O3 -I$(LUA_INCLUDE)
LDFLAGS = -L$(LUA_LIB) -llua -lcurl

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
