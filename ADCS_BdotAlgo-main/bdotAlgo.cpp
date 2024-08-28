//
//  main.cpp
//  ADCS_Bdot
//
//  Created by vertije on 17/2/21.
//

#include <iostream>
#include <math.h>

// 3x1 Vector structure for functions
typedef struct vector3 {
    float i;
    float j;
    float k;
}Vector;

float dot(Vector x, Vector y);
Vector cross(Vector x, Vector y);

//Main function code
int main(int argc, const char * argv[]) {
    // Initialisation of constants
    float N = 410,A = M_PI*pow(((5.5+0.37*2)/1000),2),M = 1,V = (M_PI*pow((5.5/1000),2))*(100/1000); // Number of turns, Area of solenoid, Magnetization of core, Volume of core
    Vector B, omega; // Initialise The magnetic field vector and angular acceleration
    B.i = 1; // Test values
    B.j = 2;
    B.k = 3;
    omega.i = 4;
    omega.j = 5;
    omega.k = 6;
    
    Vector tempCross = cross(B, omega); // Temporary variable for cross product calcs
    float temp = (-1)/(sqrt(dot(B, B))); // Determinant of magnetic field vector
    Vector mu = {temp*tempCross.i, temp*tempCross.j, temp*tempCross.k}; // Calculation for magnetic moment
    
    temp = (1/(N*A));
    Vector I = {temp*(mu.i - V*M), temp*(mu.j - V*M), temp*(mu.k - V*M)};
    
    
    printf("mu\t\t\ti %f j %f k %f\ntempCross\ti %f j %f k %f\nI\t\t\ti %f j %f k %f\nV\t\t\t%f\n", mu.i, mu.j, mu.k, tempCross.i, tempCross.j, tempCross.k, I.i, I.j, I.k, N);
    
    
    return 0;
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
