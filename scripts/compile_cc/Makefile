CC = g++
CFLAGS = -fPIC -shared

SRC := src
OBJ := obj

SOURCES := $(wildcard $(SRC)/*.c)
OBJECTS := $(patsubst $(SRC)/%.c, $(OBJ)/%.o, $(SOURCES))

all: $(OBJECTS)
	$(CC) $^ -o $@

$(OBJ)/%.o: $(SRC)/%.c
	$(CC) $(CFLAGS) -I$(SRC) -c $< -o $@

clean:
	rm -rf $(OBJ)/*.o

.PHONY: all clean