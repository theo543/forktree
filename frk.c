#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>

#include <sys/types.h>
#include <sys/wait.h>

#include "frk.h"

static bool initialized = false;
static int depth = 0;

static void close_graph(void) {
    while(wait(NULL) != -1);
    if(depth == 0) {
        printf("}\n");
    }
}

pid_t frk(void) {
    if(!initialized) {
        printf("digraph process_tree {\n");
        printf("    %d [label=\"root\"];\n", getpid());
        atexit(close_graph);
        initialized = true;
    }
    fflush(stdout);
    pid_t child = fork();
    if(child != 0) {
        printf("    %d -> %d;\n", getpid(), child);
        printf("    %d [label=\"lvl %d\"];\n", child, depth + 1);
    } else {
        depth++;
    }
    return child;
}
