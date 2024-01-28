CC = gcc
CFLAGS = -I. -Wall -Wextra -pedantic -std=c11 -g -fsanitize=address,undefined

SRCS = $(shell find src -name '*.c')
PROGS = $(patsubst src/%.c,out/%,$(SRCS))

.PHONY: all clean list

all: $(PROGS)

out/%: src/%.c frk.h frk.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -o $@ $< frk.c

clean: 
	rm -f $(PROGS)
	if [ -d out ]; then find out -type d -empty -delete; fi

list:
	@echo $(PROGS)
