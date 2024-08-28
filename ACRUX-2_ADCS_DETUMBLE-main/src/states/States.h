// #pragma once 

// #define OFF_STATE 0
// #define BOOT_STATE 1
// #define PASSIVE_STATE 2
// #define ACTIVE_STATE 3
// #define POINTING_STATE 4

// #define TRUE 1
// #define FALSE 0

// class SystemState {
//     public:
//         virtual SystemState* routine() = 0;
//         virtual void enter() = 0;
//         virtual SystemState* exit(int state_request) = 0;
//         int getState() { return this->state; };
//     private: 
//         const static int n_reachable = 0;
//         char* reachable[n_reachable] = {};
//         int state = 0;
//         int first = FALSE;
// };

// class OffState : public SystemState {
//     public:
//         SystemState* routine();
//         void enter(int state_request);
//         SystemState* exit(int state_request);
//     private:
//         const static int n_reachable = 1;
//         int reachable[n_reachable] = {BOOT_STATE};
//         int state = OFF_STATE;
// };

// class BootState : public SystemState {
//     public:
//         SystemState* routine(int state_request);
//     private:
//         void enter();
//         SystemState* exit();
//         const static int n_reachable = 1;
//         int reachable[n_reachable] = {PASSIVE_STATE};
//         int state = BOOT_STATE;
// };

// class PassiveState : public SystemState {
//     public:
//         SystemState* routine(int state_request);
//     private:
//         void enter();
//         SystemState* exit();
//         const static int n_reachable = 3;
//         int reachable[n_reachable] = {POINTING_STATE, ACTIVE_STATE, OFF_STATE};
//         int state = PASSIVE_STATE;
// };

// class ActiveState : public SystemState {
//     public:
//         SystemState* routine(int state_request);
//     private:
//         void enter();
//         SystemState* exit();
//         const static int n_reachable = 3;
//         int reachable[n_reachable] = {PASSIVE_STATE, POINTING_STATE, OFF_STATE};
//         int state = ACTIVE_STATE;
// };

// class PointingState : public SystemState {
//     public:
//         SystemState* routine(int state_request);
//     private:
//         void enter();
//         SystemState* exit();
//         const static int n_reachable = 1;
//         int reachable[n_reachable] = {ACTIVE_STATE};
//         int state = POINTING_STATE;
// };