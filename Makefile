# This will run the conversion of (currently) pure-python to C
MAIN_FILE=main

CC=gcc
STRIP=strip
CFLAGS=-shared \
        -pthread \
        -fPIC \
        -fwrapv
UNAME := $(shell uname -m)
BASEDIR=$(shell git rev-parse --show-toplevel)

OPTIMIZE=-Os
OUTPUT_DIR=build/
OPTIONS=-Wall \
        -fno-strict-aliasing \
        -D_FORTIFY_SOURCE=2 \
        -Wformat \
        -Werror=format-security \
        -Wstrict-prototypes

CROSS_COMPILE=
LINK=
INCLUDE=-I/usr/include/python3.8/
SOURCES := $(wildcard *.py)

LIBS=-lpython3.8

all : libs strip 

libs: $(filter-out $(MAIN_FILE).py,$(SOURCES))
	@mkdir -p $(OUTPUT_DIR)
	@for f in $(basename $^); do \
                echo "Converting $$f to .c file"; \
                cython -3 $$f.py -o $(OUTPUT_DIR)$$f.c; \
        done
	@echo "Converting $(MAIN_FILE) to .c file";
	@cython -3 --embed $(MAIN_FILE).py -o $(OUTPUT_DIR)$(MAIN_FILE).c
	@for f in $(basename $^); do \
                echo "Making $$f .so library"; \
                $(CROSS_COMPILE)$(CC) $(CFLAGS) $(OPTIMIZE) $(INCLUDE) $(OUTPUT_DIR)$$f.c -o $(OUTPUT_DIR)$$f.so; \
        done
	@echo "Making binary";
	@$(CROSS_COMPILE)$(CC) $(OPTIMIZE) $(INCLUDE) $(OUTPUT_DIR)$(MAIN_FILE).c $(LIBS) -o $(OUTPUT_DIR)$(MAIN_FILE)

strip: $(wildcard $(OUTPUT_DIR)*.so)
	$(CROSS_COMPILE)$(STRIP) $^
	$(CROSS_COMPILE)$(STRIP) $(OUTPUT_DIR)main

package:
	tar cf rattrap.tar $(OUTPUT_DIR)*.so $(MAIN_FILE)

clean:
	rm -rf $(OUTPUT_DIR)
