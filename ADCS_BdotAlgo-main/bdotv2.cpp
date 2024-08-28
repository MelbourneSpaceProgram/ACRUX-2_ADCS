//
//  bdotalgo.cpp
//  ADCS_Bdot
//
//  Created by vertije on 20/2/21.
//

#include "bdotalgo.hpp"
#include <math.h>
#include <stdlib.h>
#include "Wire.h"

// 3x1 Vector structure for functions
typedef struct vector3 {
    int16_t i;
    int16_t j;
    int16_t k;
}Vector;

#define BUFFER_LEN 5
int16_t mx_avg, my_avg, mz_avg;
int16_t mx[BUFFER_LEN];
int16_t my[BUFFER_LEN];
int16_t mz[BUFFER_LEN];
uint16_t idx = 0;
int16_t b;
float bInitial, bAfter, dt, mu, bDot, I, N, A, V, M;

float dot(Vector x, Vector y);
Vector cross(Vector x, Vector y);
void shiftLeft(int16_t (&array)[BUFFER_LEN]);
float averageB(int16_t (&array)[BUFFER_LEN]);

void setup() {
    Wire.begin();
    
    Serial.begin(115200);
    
    imu.initialize();
    
    imu.calibrate();
    
    for (int i = 0; i<BUFFER_LEN-1; i++){
        b = imu.getMag(mx+i, my+i, mz+i);
    }
}
// Bbefore Bafter Bdot = (Bafter-Bbefore)/dt
// mx = {1, 1, 4, 5, 7, 12, 5, 7}

void loop() {
    // AVERAGE
    bInitial = averageB(mx);
    shiftLeft(mx);
    // Assuming whatever after the "+" is the index the value is inserted into
    imu.getMag(mx+(BUFFER_LEN-1), my+(BUFFER_LEN-1), mz+(BUFFER_LEN-1));
    
    //AVERAGE
    bAfter = averageB(mx);
    
    // DT ACCURACY REQUIREMENT!?!?!?
    bDot = (bAfter-bInitial)/dt;
    
    // MULTIPLY BY k
    mu = -bDot;
    
    // I = (1/(N*A))*(mu - V*M)
    I = (1/(N*A))*(mu-V*M);
}

// Cross product function
Vector cross(Vector x, Vector y){
    float i = x.j*y.k - y.j*x.k; // Separate components of the cross product
    float j = -(x.i*y.k - y.i*x.k);
    float k = x.i*y.j - y.i*x.j;
    Vector out = {i, j, k};
    return out;
};

// Dot product function
float dot(Vector x, Vector y){
    float out = x.i*y.i + x.j*y.j + x.k*y.k;
    return out;
};

// Shift left function for array
void shiftLeft(int16_t (&array)[BUFFER_LEN]) {
    for(int i=0; i<BUFFER_LEN-1; i++){
        array[i] = array[i+1];
    }
}

// Average return
float averageB(int16_t (&array)[BUFFER_LEN]){
    int sum = 0;
    for(int i=0; i<BUFFER_LEN; i++){
        sum = sum + array[i];
    }
    float output = sum/BUFFER_LEN;
    return output;
}
