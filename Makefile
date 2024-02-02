.SECONDEXPANSION:

CC = gcc
CFLAGS = -I. -Wall -Wextra -pedantic -std=c11 -g -fsanitize=address,undefined

SRCDIR = src
OUTDIR = out
IMGDIR = img
IMGFMT = png

SRCS != find $(SRCDIR) -name '*.c'
PROGS := $(patsubst $(SRCDIR)/%.c,$(OUTDIR)/%,$(SRCS))
IMGS := $(patsubst $(SRCDIR)/%.c,$(IMGDIR)/%.$(IMGFMT),$(SRCS))

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

clean_dirs = if [ -d $(1) ]; then find $(1) -type d -empty -delete; fi

clean:
	rm -f $(PROGS) $(IMGS)
	$(call clean_dirs,$(OUTDIR))
	$(call clean_dirs,$(IMGDIR))

list:
	@echo $(PROGS)

hook: .git/hooks/pre-commit

.git/hooks/pre-commit: pre-commit
	cp $< $@
	chmod +x $@
