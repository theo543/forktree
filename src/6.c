#include "frk.h"

int main(void) {
    for(int i = 0;i < 3;i++) {
        pid_t pid = frk();
        if(pid == 0 && i > 2) {
            frk();
        }
    }
}
