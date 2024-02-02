.SECONDEXPANSION:

CC = gcc
CFLAGS = -I. -Wall -Wextra -pedantic -std=c11 -g -fsanitize=address,undefined

SRCDIR = src
OUTDIR = out
IMGDIR = img
IMGFMT = png

SRCS = $(shell find $(SRCDIR) -name '*.c')
PROGS = $(patsubst $(SRCDIR)/%.c,$(OUTDIR)/%,$(SRCS))
IMGS = $(patsubst $(SRCDIR)/%.c,$(IMGDIR)/%.$(IMGFMT),$(SRCS))

.PHONY: all clean list progs imgs hook

all: progs imgs

progs: $(PROGS)

imgs: $(IMGS)

$(PROGS): $(OUTDIR)/%: $(SRCDIR)/%.c frk.h frk.c | $$(dir $$@)
	$(CC) $(CFLAGS) -o $@ $< frk.c

$(IMGS): $(IMGDIR)/%.$(IMGFMT): $(OUTDIR)/% | $$(dir $$@)
	$< | dot -T$(IMGFMT) -o $@

$(sort $(dir $(PROGS)) $(dir $(IMGS))):
	mkdir -p $@

clean: 
	rm -f $(PROGS) $(IMGS)
	if [ -d $(OUTDIR) ]; then find $(OUTDIR) -type d -empty -delete; fi
	if [ -d $(IMGDIR) ]; then find $(IMGDIR) -type d -empty -delete; fi

list:
	@echo $(PROGS)

hook: .git/hooks/pre-commit

.git/hooks/pre-commit: pre-commit
	cp $< $@
	chmod +x $@
