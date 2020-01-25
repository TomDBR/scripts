#ifndef SHELL_CMD_H
#define SHELL_CMD_H

#define READ 	(0)
#define WRITE 	(1)
typedef struct process {
	pid_t pid;
	int fd;
} process_t;

process_t process(char *cmd[]);

#endif
