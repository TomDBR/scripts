#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/wait.h>
#include "util.h"
#include "shell_cmd.h"

#define ID_SIZE (11)

static char *directions[4] = { "top", "bottom", "left", "right" };
static int verbose = 1;

struct state {
	int selectedChild;
	int child1;
	int child2;
	int splitType; // 0: horizontal, 1: vertical
} *state;

int validInput(char *direction) 
{
	if (strcmp(direction, "up") == 0) return 1;
	if (strcmp(direction, "down") == 0) return 2;
	if (strcmp(direction, "left") == 0) return 3;
	if (strcmp(direction, "right") == 0) return 4;
	else return 0;
}

struct state *getState()
{
	FILE *f = NULL;
	char *focusedChild[] = { "bspc", "query", "-N", "-n", NULL};
	char *jsonParent[] = { "bspc", "query", "-T", "-n", "@parent", NULL};
	char *jq[] = { "jq", "-r", ".splitType,.firstChild.id,.secondChild.id", NULL};
	char tmp[20];
	struct state *s = malloc(sizeof(struct state));

	process_t p1 = process(jsonParent);
	process_t p2 = process(jq);

	f = fdopen(p1.fd_write, "r");
	if (f == NULL) die("Failed to open descriptor as file.\n");
	for (char ch = 0; (ch = fgetc(f)) != EOF;) {
		dprintf(p2.fd_read, "%c", ch); // send json output to jq
	}
	fclose(f); close(p2.fd_read); // done writing to jq

	f = fdopen(p2.fd_write, "r");
	if (f == NULL) 
		die("Failed to open descriptor as file.\n");
	fscanf(f, "%s\n%8d\n%8d", tmp, &(s->child1), &(s->child2));
	fclose(f);
	s->splitType = strcmp(tmp, "horizontal") == 0 ? 0 : 1;

	process_t p3 = process(focusedChild);
	close(p3.fd_read); // we're not writing anything to this process
	unsigned int t = 0;
	f = fdopen(p3.fd_write, "r");
	if (f == NULL) die("");
	fscanf(f, "%x\n", &t);
	fclose(f);
	printf("dec: %d, hex: %#010X\n", t, t);
	s->selectedChild = t;
	//read(p3.fd_write, &s->selectedChild, sizeof(int));

	close(p3.fd_write); close(p1.fd_read); close(p1.fd_write); close(p2.fd_write);
	return s;
}

void runCmd(char *args[]) {
	for (int i = 0; args[i] != NULL; i++) {
		printf("%s ", args[i]);
	}
	printf("\n");
}

int main(int argc, char *argv[]) {
	int dir = 0, x = 0, y = 0;
	if (argc != 2) die("Usage: resize_win [direction]\n\t- direction: up, down, left, right");
	if (!(dir = validInput(argv[1]))) die("Invalid direction!");
	struct state *s = getState();
	printf("split: %d\tselected: %d\tchild 1: %d,\tchild2: %d\n", s->splitType, s->selectedChild, s->child1, s->child2);
	switch (s->splitType) {
		case 0: //horizontal
			if (verbose) printf("Horizontal split, ");
			x = 0;
			switch (dir) {
				case 1: // up
					if (verbose) printf("moving up.");
					y = -20;
					dir = s->child1 == s->selectedChild ? 2 : 1;
					break;
				case 2: // down
					if (verbose) printf("moving down.");
					y = 20;
					dir = s->child1 == s->selectedChild ? 2 : 1;
					break;
				default:
					fprintf(stderr, "Invalid direction!\n");
					goto exit;
			}
			break;
		case 1: // vertical
			if (verbose) printf("Vertical split, ");
			y = 0;
			switch (dir) {
				case 3: // left
					if (verbose) printf("moving left.");
					x = -20;
					dir = s->child1 == s->selectedChild ? 4 : 3;
					break;
				case 4: // right
					if (verbose) printf("moving right.");
					x = 20;
					dir = s->child1 == s->selectedChild ? 4 : 3;
					break;
				default:
					fprintf(stderr, "Invalid direction!!\n");
					goto exit;
			}
			break;
	}
	if (verbose) printf("\n");

	char xTxt[10], yTxt[10];
	sprintf(xTxt, "%d", x); sprintf(yTxt, "%d", y);
	char *bspc[] = { "bspc", "node", "-z", directions[dir-1], xTxt, yTxt, NULL };
	if (verbose) runCmd(bspc);
	process_t p = process(bspc);
	close(p.fd_read); close(p.fd_write);
	wait(NULL);
	return 0;
exit:
	free(s);
	return 1;
}
