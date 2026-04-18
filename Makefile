CXX = clang++
CXXFLAGS = -std=c++17 -Wall -O3
LDFLAGS = -llua -lcurl

SRC = src/gui.mm src/main.cpp
OBJ = $(SRC:.mm=.o)
TARGET = RobloxExecutor

all: $(TARGET)

$(TARGET): $(OBJ)
	$(CXX) $(OBJ) -o $(TARGET) $(LDFLAGS) -framework Cocoa

%.o: %.mm
	$(CXX) $(CXXFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(TARGET)
