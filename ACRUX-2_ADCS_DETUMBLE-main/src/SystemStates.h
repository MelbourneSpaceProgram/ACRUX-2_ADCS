#ifndef SYSTEM_STATES_H
#define SYSTEM_STATES_H

#include <Arduino.h>

class SystemStates {
    public:
        SystemStates();
        void run_state(int cmd);
        int get_state();

        const static int BLANK = -1;
        const static int OFF = 0;
        const static int BOOT_SEQ = 1;
        const static int PASSIVE = 2;
        const static int ACTIVE = 3;
        const static int POINTING = 4;
        const static int TOTAL_STATES = 5;
    private:
        void state_off();
        void state_boot_seq();
        void state_passive();
        void state_active();
        void state_pointing();
        
        int state = OFF;
        int prev_state = OFF;
        int obc_cmd = BLANK;

        unsigned long time_sys = 0;
        unsigned long time_sys_0 = 0;
        unsigned long bounce_delay = 5;

        const String state_list[TOTAL_STATES] = {"OFF", "BOOT_SEQ", "PASSIVE", "ACTIVE", "POINTING"};
};

#endif