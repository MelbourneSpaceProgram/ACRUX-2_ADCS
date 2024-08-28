#include "SystemStates.h"

SystemStates::SystemStates() {
  // No init's right now
}

void SystemStates::run_state(int cmd) {
  // TODO: implement delay for switch bouncing
  time_sys = millis();
  obc_cmd = cmd;

  switch (state) {
    case OFF:
      state_off();
      break;
    case BOOT_SEQ:
      state_boot_seq();
      break;
    case PASSIVE:
      state_passive();
      break;
    case ACTIVE:
      state_active();
      break;
    case POINTING:
      state_pointing();
      break;

  } 
}

/*
 * System State = OFF
*/

void SystemStates::state_off() {
  // Immediately proceed to boot sequence
  prev_state = OFF;
  state = BOOT_SEQ;
  Serial.println(state_list[prev_state]+" -> "+state_list[state]);
}

/*
 * System State = BOOT_SEQ
*/

void SystemStates::state_boot_seq() {
  // Entry Operations
  if (prev_state == OFF) {
    // Run diagnostics

    prev_state = BOOT_SEQ;
  }

  // Exit Operations
  else if (obc_cmd == PASSIVE) {
    state = PASSIVE;
    Serial.println(state_list[prev_state]+" -> "+state_list[state]);
  }

  else if (obc_cmd != BLANK) {
    Serial.println("Invalid state change request!");
  }
}

/*
 * System State = PASSIVE
*/

void SystemStates::state_passive() {
  //Entry Operations
  if (prev_state == BOOT_SEQ) {
    // Turn on magnetometers

    prev_state = PASSIVE;
  }

  else if (prev_state == ACTIVE) {
    // Turn off magnetorquers

    prev_state = PASSIVE;
  }

  // Exit Operations
  else if (obc_cmd == POINTING) {
    // Turn on reaction wheels / magnetorquers

    state = POINTING;
    Serial.println(state_list[prev_state]+" -> "+state_list[state]);
  }

  else if (obc_cmd == ACTIVE) {
    // Turn on magnetorquers

    state = ACTIVE;
    Serial.println(state_list[prev_state]+" -> "+state_list[state]);
  }

  else if (obc_cmd == OFF) {
    // Turn off system
    // Does shut-down need to be a seperate state?

    state = OFF;
    Serial.println(state_list[prev_state]+" -> "+state_list[state]);
  }

  else if (obc_cmd != BLANK) {
    Serial.println("Invalid state change request!");
  }

  // Idle Operations
  else {
    // Get data from MPU
  }
}

/*
 * System State = ACTIVE
*/

void SystemStates::state_active() {
  // Entry Operations
  if (prev_state == PASSIVE) {
    // Turn on magnetorquers

    prev_state = ACTIVE;
  }

  else if (prev_state == POINTING) {
    // De-saturate

    prev_state = ACTIVE;
  }

  // Exit Operations
  else if (obc_cmd == PASSIVE) {

    state = PASSIVE;
    Serial.println(state_list[prev_state]+" -> "+state_list[state]);
  }

  else if (obc_cmd == POINTING) {

    state = POINTING;
    Serial.println(state_list[prev_state]+" -> "+state_list[state]);
  }

  else if (obc_cmd != BLANK) {
    Serial.println("Invalid state change request!");
  }

  // Idle Operations
  else {
    // Point at something
  }
}

/*
 * System State = POINTING
*/

void SystemStates::state_pointing() {
  // Entry Operations
  if (prev_state == PASSIVE) {
    // Turn on magnetorquers / reaction wheels 

    prev_state = POINTING;
  }

  else if (prev_state == ACTIVE) {
    // De-saturate

    prev_state = POINTING;
  }

  // Exit Operations
  else if (obc_cmd == ACTIVE) {

    state = ACTIVE;
    Serial.println(state_list[prev_state]+" -> "+state_list[state]);
  }

  else if (obc_cmd != BLANK) {
    Serial.println("Invalid state change request!");
  }

  // Idle Operations
  else {
    // Point
  }
}