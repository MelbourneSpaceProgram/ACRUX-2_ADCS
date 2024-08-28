#include <Arduino.h>
#include "I2Cdev.h"
#include "Wire.h"
//#include "helpeI2Cdev.h"
#include "algorithms/BdotController.h"
#include "actuators/Torquer.h"
#include "BluetoothSerial.h"
// #include "telemetry.hpp"
// #include "states/States.h"

bool blinkState = false;
// const static uint32_t MAGTASK_STACK_SIZE = 25000;

BDotController magwatcher;
Torquer x_rod(14, 27, 26, 0);
Torquer y_rod(25, 33, 32, 1);

BluetoothSerial ESP_BT;

void setup() {
  Serial.begin(115200);

  uint8_t status = 0;
  // join I2C bus (I2Cdev library doesn't do this automatically)
  Wire.begin();

  // initialize serial communication
  Serial.begin(115200);
  if(!ESP_BT.begin("ESP32")){
	  Serial.println("Bluetooth Initilisation Error.");
  }

	// For testing:
	// telemetry::init();


  // Initialize the magnetometer viewer
  magwatcher.init();

	status = magwatcher.hardwareCheck();
	if (status != 0){
		if (status&0x01) Serial.println("IMU connection failure");
		if (status&0x02) Serial.println("magnetometer connection failure");
	}


  // configure LED pin for output
  pinMode(LED_BUILTIN, OUTPUT);

	// Call torquer initialisation routines (these set up the pins and
	// configure PWM channels)
  x_rod.init();
  y_rod.init();

	// 	// Sets maximum allowable PWM duty cycle
  x_rod.set_max_power(0.5);
  y_rod.set_max_power(0.5);
}

const uint BUFLEN=128;

char B_buffer[BUFLEN];
char W_buffer[BUFLEN];
char big_buffer[BUFLEN*2];

void loop() {
  static vector3_f B;
  static vector3_f W;

	magwatcher.poll_magnetometer();
	magwatcher.poll_gyro();

	
	magwatcher.get_W(W);
	// send gyro data via bluetooth
	W.str(W_buffer, BUFLEN, "%4.3f %4.3f %4.3f ");
	Serial.println(W_buffer);
	if(ESP_BT.available()){
		ESP_BT.print(W_buffer);
		ESP_BT.print("\n");
	}


	magwatcher.get_Bdot(B);
	// send B dot data via bluetooth
	//B.str(B_buffer, BUFLEN, "%4.3f %4.3f %4.3f ");
	//Serial.println(B_buffer);
	//if(ESP_BT.available()){
	//	ESP_BT.print(B_buffer);
	//	ESP_BT.print("\n");
	//}
	
	// Normalise so that dx/dt and dy/dt are at most 1
	float biggest = max(abs(B.x), abs(B.y));
	B /= biggest;

	x_rod.actuate(B.x);
	y_rod.actuate(B.y);


	magwatcher.get_raw_B(B);
	B.str(B_buffer, BUFLEN, "%2.2f\t%2.2f\t%2.2f");
	snprintf(big_buffer, BUFLEN,"%5d\t",millis());
	strncat(big_buffer, B_buffer, BUFLEN);

	// send raw magnetic field data via bluetooth
	//B.str(B_buffer, BUFLEN, "%4.3f %4.3f %4.3f ");
	//Serial.println(B_buffer);
	//if(ESP_BT.available()){
	//	ESP_BT.print(B_buffer);
	//	ESP_BT.print("\n");
	//}
	//B_as_json(sendbuf, B_BUFFER*10);
	//telemetry::events.send(big_buffer,"mag_readings",millis());
    

	digitalWrite(LED_BUILTIN, blinkState);
	blinkState=!blinkState;
	delay(100);

}

// Ignore this while we work on hardware - can be part of bells and whistles. 

// #define INBUILT_LED 2

// SystemState* state;

// void setup() {
//   Serial.begin(115200);

//   // Initialize state of ADCS to OFF
//   OffState offState;
//   state = &offState;
// }

// /*
//  * Control Loop
// */
// void loop() {

//   // Handle input and run state
//   int cmd = -1;

//   if (Serial.available() > 0) {
//     int input = Serial.parseInt();

//     if (input >= 0 && input < 4) {
//       cmd = input; 
//     }
//   }

//   if (cmd != state->getState()) {
//     state = state->exit(cmd);
//     state->enter();

//   }

//   state = state->routine(cmd);
// }