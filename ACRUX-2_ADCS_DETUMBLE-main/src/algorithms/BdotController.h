#ifndef BDOT_CTRL_H
#define BDOT_CTRL_H

#include "../sensors/MPU9150_fixed.h"
#include "../helper/vectormath.h"
#include "Ticker.h"
#include "esp_timer.h"
#include <algorithm>

// Maximum and minimum field readings
#define AK8975_H_OL_POS 4095
#define AK8975_H_OL_NEG -4096

typedef Vector3<float> mag_t;
typedef Vector3<float> vector3_f;


class BDotController {
public:
    BDotController(){

    }
    // Calls the relevant initialiser functions
    // this lives, morally, in setup()
    void init();
    uint8_t hardwareCheck();
    // sets the time constant of the internal lowpass filter
    void set_tau(float t){
        tau = t;
    }
    // Records an updated magnetometer reading, along with the time
    void poll_magnetometer();
    // Retrieves a lowpass filtered balue of B, based on N records
    void get_avg_B(vector3_f& B, uint16_t N);
    // retrieves most recent reading, without filtering
    void get_raw_B(vector3_f& B);
    // retrieves dB/dt in a finite differenced manner
    void get_Bdot(vector3_f& B, uint16_t N);
    void get_Bdot(vector3_f& B){
        get_Bdot(B, BUFFER_LEN-1);
    }
    // get gyro readings
    void poll_gyro();
    void get_W(vector3_f& W);

private:
    // class default I2C address is 0x68
    // specific I2C addresses may be passed as a parameter here
    // AD0 low = 0x68 (default for InvenSense evaluation board)
    // AD0 high = 0x69
    MPU9150 imu;

    float tau; // time constant of filter, microseconds

    // Vector3<float> avg_m;

    // Stores sensitivity correcitions for raw magnetometer reads
    Vector3<float> sens_correction;

    static const int BUFFER_LEN = 10;
    // volatile mag_t history[BUFFER_LEN];
    // volatile int64_t t_history[BUFFER_LEN];
    // volatile uint16_t hist_idx; // points to a the index of the most recent valid read, avoiding the need for rippling
    mag_t history_gyro[BUFFER_LEN];
    mag_t history[BUFFER_LEN];
    int64_t t_history[BUFFER_LEN];
    uint16_t hist_idx; // points to a the index of the most recent valid read, avoiding the need for rippling
    static_assert(BUFFER_LEN < (uint16_t) 65535, "buffer is too long for index datatype to store"); // needed to ensure we don't have weird overflows
    // Storage format: [ 5 4 3 2 1 9 8 7 6 ]
    // i.e. n^th most recent record found at history[(hist_idx+n) % BUFFER_LEN], 

    // void update_log();
};

#endif