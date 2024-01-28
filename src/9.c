#include "frk.h"

int main(void) {
    for(int i = 0;i < 2;i++) {
        if(frk()) {
            if(frk()) {
                break;
            }
        }
    }
}
