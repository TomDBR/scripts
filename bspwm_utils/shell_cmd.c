#include <unistd.h>
#include "shell_cmd.h"

process_t process(char *cmd[]) {
	int ppipe[2];
	pipe(ppipe);
	process_t process = { fork(), ppipe[READ] };
	if (process.pid == 0) { // child process
		dup2(ppipe[WRITE], STDOUT_FILENO);
		close(ppipe[READ]); close(ppipe[WRITE]);
		execvp(cmd[0], cmd);
	}
	close(ppipe[WRITE]); // close this end in parent
	return process;
}
