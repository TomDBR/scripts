CC		:= gcc
CFLAGS		:= -Wall -Wextra -Wpedantic 
	
PREFIX    	:= /usr/local
BINPREFIX 	:= $(PREFIX)/bin

ifeq ($(DEBUG),1)
	CFLAGS+=-DDEBUG -g
endif

SRC		:= $(wildcard *.c)
OBJ 		:= $(SRC:.c=.o)
VALG 		:= $(wildcard vgcore.*)

all: 		scratchpad_util

$(OBJ): 	Makefile

scratchpad_util: 	$(OBJ)



install: 
	mkdir -p "$(DESTDIR)$(BINPREFIX)"
	cp -p scratchpad_util "$(DESTDIR)$(BINPREFIX)"

uninstall:
	rm -f "$(DESTDIR)$(BINPREFIX)/scratchpad_util"

clean: 	
	rm -f scratchpad_util $(OBJ) $(VALG)


