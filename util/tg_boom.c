/*
  Threaded version, based on "pseudocc.c" by Masahito Suzuki
     https://github.com/firelzrd/bore-scheduler/tree/main/tests

  2024-12-14
     Utility for checking BORE and stuck thread

  Examples
     for i in $(seq 1 40); do echo "# $i"; time ./tg_boom -j32 -l6; echo; done
     time ./tg_boom -j$(nproc) -l2 1e7   # simulate work
     time ./tg_boom -j$(nproc) -l6 0     # no task loop (default 0)

  Build with
     gcc -o tg_boom -pthread tg_boom.c
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
#include <pthread.h>

struct task_args {
  int level;
  uint64_t cycles;
  int direct_task;
};

int fds[2];

// Display usage information
void display_usage()
{
  printf("tg_boom v1.0\n");
  printf("BORE (Burst-Oriented Response Enhancer) Burst time inheritance test\n");
  printf("Usage: ./tg_boom [-j <parallelism>] [-l <level>] [ N ]\n");
  printf("Specify N for the tasks to simulate work e.g. 1e7\n");
}

// Create tasks recursively and run the loop
void *run_loop_in_tasks(void *arg);

// Create a new task and run the loop function
pthread_t create_task(void *arg)
{
  struct task_args *args = (struct task_args *)arg;
  pthread_t tid;

  if (pthread_create(&tid, NULL, run_loop_in_tasks, (void *)args)) {
    perror("Failed to create thread");
    exit(1);
  } else if (args->direct_task) {
    pthread_detach(tid); // Detach from the main thread
  }

  return tid;
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
    pthread_t tid = create_task((void *)&nested_args);
    pthread_join(tid, NULL);
  }

  if (args->direct_task) write(fds[1], "", 1);

  pthread_exit(NULL);
}

// Maintain parallelism
void maintain_parallelism(int parallelism, int level, int cycles)
{
  int running_tasks = 0;
  int count = 25000;
  uint64_t total = 0;
  char buf[1];

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

