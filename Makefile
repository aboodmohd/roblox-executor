CXX = clang++
# Explicitly try common Homebrew paths
BREW_PREFIX = $(shell brew --prefix)
LUA_INCLUDE = $(BREW_PREFIX)/include/lua
# Fallback if BREW_PREFIX is empty
ifeq ($(BREW_PREFIX),)
    LUA_INCLUDE = /usr/local/include/lua
endif

CXXFLAGS = -std=c++17 -Wall -O3 -I$(LUA_INCLUDE)
LDFLAGS = -L$(BREW_PREFIX)/lib -llua -lcurl

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
