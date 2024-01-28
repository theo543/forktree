CC = gcc
CFLAGS = -I. -Wall -Wextra -pedantic -std=c11 -g -fsanitize=address,undefined

SRCS = $(shell find src -name '*.c')
PROGS = $(patsubst src/%.c,out/%,$(SRCS))
PNGS = $(patsubst src/%.c,img/%.png,$(SRCS))

.PHONY: all clean list progs pngs

all: progs pngs

progs: $(PROGS)

pngs: $(PNGS)

out/%: src/%.c frk.h frk.c
	mkdir -p $(dir $@)
	$(CC) $(CFLAGS) -o $@ $< frk.c

img/%.png: out/%
	mkdir -p $(dir $@)
	$< | dot -Tpng -o $@

clean: 
	rm -f $(PROGS) $(PNGS)
	if [ -d out ]; then find out -type d -empty -delete; fi
	if [ -d img ]; then find img -type d -empty -delete; fi

list:
	@echo $(PROGS)
