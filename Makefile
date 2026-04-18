CXX = clang++
# Add Homebrew include path for Lua
LUA_INCLUDE = $(shell brew --prefix)/include/lua5.4
CXXFLAGS = -std=c++17 -Wall -O3 -I$(LUA_INCLUDE)
LDFLAGS = -L$(shell brew --prefix)/lib -llua5.4 -lcurl

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
