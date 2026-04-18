CXX = clang++
# Print include paths for debugging
$(info Checking for Lua headers...)
$(info $(shell ls /opt/homebrew/include/lua*))

LUA_INCLUDES = -I/usr/local/include/lua -I/usr/local/include/lua5.4 -I/opt/homebrew/include/lua -I/opt/homebrew/include/lua5.4
CXXFLAGS = -std=c++17 -Wall -O3 $(LUA_INCLUDES)
LDFLAGS = -L$(shell brew --prefix)/lib -llua -lcurl

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
