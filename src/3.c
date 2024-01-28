#include "frk.h"

int main(void) {
    for(int x = 0;x < 3;x++) {
        if(frk() == 0) {
            if(x != 0) {
                frk();
            }
            break;
        }
    }
}
