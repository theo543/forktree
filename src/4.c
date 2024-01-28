#include "frk.h"

int main(void) {
    for(int x = 0;x < 3;x++) {
        thread_create();
        frk();
        frk();
    }
}
