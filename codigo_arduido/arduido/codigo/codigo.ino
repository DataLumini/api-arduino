const int pinoSensor = A3; 

void setup() {
  Serial.begin(9600);
}

void loop() {
  // Lê o valor bruto do sensor LDR (que varia de 0 a 1023)
  int valorBruto = analogRead(pinoSensor);
  int valorConvertido = valorBruto * (205.0 / 1023.0);

  // Envia APENAS o número final pela serial para o Node.js capturar
  Serial.println(valorConvertido);

  // Aguarda 1 minuto antes da próxima leitura
  delay(60000); 
}