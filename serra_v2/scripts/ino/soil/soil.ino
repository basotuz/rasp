const int SOIL_SENSOR_PIN = A0;
const int DRY_READING = 1023;
const int WET_READING = 445;
const unsigned long SERIAL_BAUDRATE = 9600;
const unsigned long LOOP_DELAY_MS = 2000;

void setup() {
  Serial.begin(SERIAL_BAUDRATE);
}

void loop() {
  int rawValue = analogRead(SOIL_SENSOR_PIN);

  int soilPercent = map(rawValue, DRY_READING, WET_READING, 0, 100);
  soilPercent = constrain(soilPercent, 0, 100);

  Serial.print("soil=");
  Serial.print(soilPercent);
  Serial.print(";raw=");
  Serial.println(rawValue);

  delay(LOOP_DELAY_MS);
}
