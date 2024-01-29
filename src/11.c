#include "frk.h"

int main(void) {
    if(frk() == 0) {
        for(int i = 3;i <= 7;i++) {
            if(frk() == 0) {
                if(i == 3 || i == 7) {
                    if(frk() == 0) {
                        frk();
                    }
                }
                break;
            }
        }
    }
}
