.SECONDEXPANSION:

CC = gcc
CFLAGS = -I. -Wall -Wextra -pedantic -std=c11 -g -fsanitize=address,undefined

SRCDIR = src
OUTDIR = out
IMGDIR = img
IMGFMT = png
DOTVER = $(IMGDIR)/dot_version.txt
DOTCMD = dot

SRCS != find $(SRCDIR) -name '*.c'
PROGS := $(patsubst $(SRCDIR)/%.c,$(OUTDIR)/%,$(SRCS))
IMGS := $(patsubst $(SRCDIR)/%.c,$(IMGDIR)/%.$(IMGFMT),$(SRCS))

.PHONY: all clean list progs imgs hook dotver

all: progs imgs

progs: $(PROGS)

imgs: $(IMGS) $(DOTVER)

$(PROGS): $(OUTDIR)/%: $(SRCDIR)/%.c frk.h frk.c | $$(dir $$@)
	$(CC) $(CFLAGS) -o $@ $< frk.c

$(IMGS): $(IMGDIR)/%.$(IMGFMT): $(OUTDIR)/% | $$(dir $$@)
	$< | $(DOTCMD) -T$(IMGFMT) -o $@

dotver: $(DOTVER)

$(DOTVER): | $(dir $(DOTVER))
	$(DOTCMD) -V > $@ 2>&1

$(sort $(dir $(PROGS)) $(dir $(IMGS)) $(dir $(DOTVER))):
	mkdir -p $@

clean_dirs = if [ -d $(1) ]; then find $(1) -type d -empty -delete; fi

clean:
	rm -f $(PROGS) $(IMGS) $(DOTVER)
	$(call clean_dirs,$(OUTDIR))
	$(call clean_dirs,$(IMGDIR))

print_var = $(info $(1) = $(sort $($(1))))

list:
	$(call print_var,SRCS)
	$(call print_var,PROGS)
	$(call print_var,IMGS)
	@:

hook: .git/hooks/pre-commit

.git/hooks/pre-commit: pre-commit
	cp $< $@
	chmod +x $@
