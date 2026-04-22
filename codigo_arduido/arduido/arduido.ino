const int PINO_SENSOR_LDR = A4;
int valorLuminosidade;

const float PPFD_fator = 0.017; 

void setup() {
  Serial.begin(9600);
}

void loop() {
  valorLuminosidade = analogRead(PINO_SENSOR_LDR);

  float voltagem = valorLuminosidade * (5.0 / 1023.0);
  if (voltagem > 4.98) voltagem = 4.98;

  float resistencia = (5.0 * 10000.0 / voltagem) - 10000.0;
  /* O método pow calcula a potência, separando os valores por vírgula */
  float lux = 500.0 * pow((resistencia / 1000.0), -1.4); 

  float ppfd = lux * PPFD_fator;

  Serial.print("Luminosidade:"); 
  Serial.println(ppfd);
  
  delay(2000);
}
