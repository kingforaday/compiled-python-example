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

all : libs main 

libs: $(filter-out $(MAIN_FILE).py,$(SOURCES))
	@mkdir -p $(OUTPUT_DIR)
	@for f in $(basename $^); do \
                echo "Converting $$f.py to .c file"; \
                cython -3 $$f.py -o $(OUTPUT_DIR)$$f.c; \
        done
	@for f in $(basename $^); do \
                echo "Making $$f.so library"; \
                $(CROSS_COMPILE)$(CC) $(CFLAGS) $(OPTIMIZE) $(INCLUDE) $(OUTPUT_DIR)$$f.c -o $(OUTPUT_DIR)$$f.so; \
        done
	@for f in $(basename $^); do \
                echo "Strip $$f.so library"; \
		$(CROSS_COMPILE)$(STRIP) $(OUTPUT_DIR)$$f.so; \
        done

main:
	@echo "Converting $(MAIN_FILE).py to .c file";
	@cython -3 --embed $(MAIN_FILE).py -o $(OUTPUT_DIR)$(MAIN_FILE).c
	@echo "Making binary";
	@$(CROSS_COMPILE)$(CC) $(OPTIMIZE) $(INCLUDE) $(OUTPUT_DIR)$(MAIN_FILE).c $(LIBS) -o $(OUTPUT_DIR)$(MAIN_FILE)
	$(CROSS_COMPILE)$(STRIP) $(OUTPUT_DIR)main

clean:
	rm -rf $(OUTPUT_DIR)
