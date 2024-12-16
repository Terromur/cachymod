/*
  Fork version, based on "pseudocc.c" by Masahito Suzuki
     https://github.com/firelzrd/bore-scheduler/tree/main/tests

  2024-12-14
     Utility for checking BORE and stuck process

  Examples
     for i in $(seq 1 40); do echo "# $i"; time ./topo_boom -j32 -l6; echo; done
     time ./topo_boom -j$(nproc) -l2 1e8   # simulate work
     time ./topo_boom -j$(nproc) -l6 0     # no task loop (default 0)

  Build with
     gcc -o topo_boom topo_boom.c
*/
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <getopt.h>
#include <stdint.h>
#include <string.h>
#include <time.h>
#include <signal.h>

struct task_args {
  int level;
  uint64_t cycles;
  int direct_task;
};

int fds[2];

// Display usage information
void display_usage()
{
  printf("topo_boom v1.0\n");
  printf("BORE (Burst-Oriented Response Enhancer) Burst time inheritance test\n");
  printf("Usage: ./topo_boom [-j <parallelism>] [-l <level>] [ N ]\n");
  printf("Specify N for the tasks to simulate work e.g. 1e7\n");
}

// Create tasks recursively and run the loop
void *run_loop_in_tasks(void *arg);

// Create a new task and run the loop function
pid_t create_task(void *arg)
{
  struct task_args *args = (struct task_args *)arg;
  pid_t pid = fork();

  if (pid < 0) {
    perror("Failed to create process");
    exit(1);
  } else if (pid == 0) {
    run_loop_in_tasks((void *)args);
  }

  return pid;
}

// Create tasks recursively and run the loop
void *run_loop_in_tasks(void *arg)
{
  struct task_args *args = (struct task_args *)arg;

  if (args->cycles && args->level <= 0) {
    uint64_t result = args->cycles;
    volatile uint64_t j; // Prevent compile-time loop optimization
    for (j = 0; j < result; j++) {
      // Empty loop
    }
  }

  if (args->level > 0) {
    struct task_args nested_args = { args->level - 1, args->cycles, 0 };
    pid_t pid = create_task((void *)&nested_args);
    waitpid(pid, NULL, 0);
  }

  if (args->direct_task) write(fds[1], "", 1);

  exit(0);
}

// Maintain parallelism
void maintain_parallelism(int parallelism, int level, int cycles)
{
  int running_tasks = 0;
  int count = 25000;
  uint64_t total = 0;
  char buf[1];

  // Ignore SIGCHLD signal
  struct sigaction sa;
  sa.sa_handler = SIG_DFL;
  sa.sa_flags = SA_NOCLDWAIT;
  sigaction(SIGCHLD, &sa, NULL);

  while (1) {
    for (int i = 0; i < parallelism - running_tasks; i++) {
      struct task_args args = { level - 1, cycles, 1 };
      create_task((void *)&args);
      running_tasks++;
      total++;
    }
    // Wait for any direct task to finish
    read(fds[0], buf, 1);
    running_tasks--;
    if (!--count) break;
  }

  // Wait for remaining direct tasks to finish
  while (running_tasks > 0) {
    read(fds[0], buf, 1);
    running_tasks--;
  }

  printf("total tasks spawned %lu\n", total * level);
}

int main(int argc, char *argv[])
{
  int cores = sysconf(_SC_NPROCESSORS_ONLN);
  int parallelism = cores;
  int level = 1;
  uint64_t cycles = 0UL;

  // Disable output buffer
  setvbuf(stdout, NULL, _IONBF, 0);

  if (pipe(fds) == -1) {
    perror("Pipe creation failed");
    return 1;
  }

  // Process the -j and -l command line options
  int option;
  while ((option = getopt(argc, argv, "j:l:")) != -1) {
    switch (option) {
      case 'j':
        parallelism = atoi(optarg);
        break;
      case 'l':
        level = atoi(optarg);
        break;
      default:
        display_usage();
        return 1;
    }
  }

  if (optind < argc)
    cycles = (uint64_t) strtold(argv[optind], NULL);

  printf("Number of CPU cores: %d\n", cores);
  printf("Parallelism: %d\n", parallelism);
  printf("Level: %d\n", level);

  maintain_parallelism(parallelism, level, cycles);

  // Close the pipe read and write handles
  close(fds[0]);
  close(fds[1]);

  return 0;
}

