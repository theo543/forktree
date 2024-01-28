#include "frk.h"

int main(void) {
    for(int x = 0;x < 3;x++) {
        frk();
        thread_create();
        frk();
    }
}
