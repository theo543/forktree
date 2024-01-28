#include "frk.h"

int main(void) {
    if(frk()) {
        thread_create();
        if(frk()) {
            thread_create();
        } else {
            frk();
        }
    }
}
