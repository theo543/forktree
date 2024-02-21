#define _DEFAULT_SOURCE

#include <stdatomic.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#include <sys/types.h>
#include <sys/wait.h>
#include <sys/mman.h>
#include <unistd.h>

#include "frk.h"

struct shared_data {
    atomic_int total_threads;
    atomic_int total_processes;
};

static bool initialized = false;
static int depth = 0;
static int thread_nr = 0;
static struct shared_data *shared_data = NULL;

static void close_graph(void) {
    while(wait(NULL) != -1);
    char label_buf[128] = "root";
    int label_len = 4;
    if(depth > 0) {
        label_len = sprintf(label_buf, "lvl %d", depth);
    }
    if(thread_nr > 0) {
        sprintf(label_buf + label_len, "\\nT: %d", thread_nr);
    }
    printf("    %d [label=\"%s\"];\n", getpid(), label_buf);
    if(depth == 0) {
        if(shared_data->total_threads > 0) {
            printf("    label=\"Total threads: %d\\nTotal processes: %d\";\n", shared_data->total_threads, shared_data->total_processes);
        } else {
            printf("    label=\"Total processes: %d\";\n", shared_data->total_processes);
        }
        printf("}\n");
    }
    if(munmap(shared_data, sizeof(struct shared_data)) == -1) {
        perror("munmap");
    }
}

static void initialize(void) {
    if(initialized) {
        return;
    }
    shared_data = mmap(NULL, sizeof(struct shared_data), PROT_READ | PROT_WRITE, MAP_SHARED | MAP_ANONYMOUS, -1, 0);
    if(shared_data == MAP_FAILED) {
        perror("mmap");
        exit(1);
    }
    shared_data->total_threads = 0;
    shared_data->total_processes = 1;
    printf("digraph process_tree {\n");
    atexit(close_graph);
    initialized = true;
}

pid_t frk(void) {
    initialize();
    fflush(stdout);
    pid_t child = fork();
    if(child != 0) {
        printf("    %d -> %d;\n", getpid(), child);
    } else {
        depth++;
        thread_nr = 0;
        shared_data->total_processes++;
    }
    return child;
}

void thread_create(void) {
    initialize();
    thread_nr++;
    shared_data->total_threads++;
}
