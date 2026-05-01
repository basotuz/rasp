int sensore = A0;

int secco = 1023;
int bagnato = 445;

void setup() {
  Serial.begin(9600);
}

void loop() {
  int valore = analogRead(sensore);

  int percentuale = map(valore, secco, bagnato, 0, 100);
  percentuale = constrain(percentuale, 0, 100);

  Serial.print("soil=");
  Serial.print(percentuale);
  Serial.print(";raw=");
  Serial.println(valore);

  delay(2000);
}
