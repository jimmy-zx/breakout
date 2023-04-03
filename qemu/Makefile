CC=mips-linux-gnu-gcc
LIB=./marsemu/build/*.o drawbox.o getbox.o drawfont.o drawstr.o
CFLAGS=-g

.PHONY: server rdebug rgdb

all: game

game_start.o: game_start.s gdefs.s

game: qemurun.o game.o game_init.o game_start.o game_input.o game_tick.o game_render.o game_deinit.o game_sleep.o game_collide.o game_score.o font.o game_menu.o $(LIB)
	$(CC) $(CFLAGS) -o $@ $^ -static

run_drawfont: run_drawfont.s drawfont.s font.s $(LIB)
	$(CC) $(CFLAGS) -o $@ $^ -static

%.o: %.s
	$(CC) $(CFLAGS) -o $@ -c $<

server:
	-touch /tmp/marsemu_kbd
	-touch /tmp/marsemu_vfb
	./marsemu/build/server

rgame: game
	qemu-mips ./game

rdebug: game
	qemu-mips -g 1234 ./game

rgdb:
	gdb-multiarch ./game

nomacro: game
	./makenomacro.sh
