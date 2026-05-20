// const int PINO_SENSOR_LDR = A4;
// int valorLuminosidade;

// const float PPFD_fator = 0.017; 

// void setup() {
//   Serial.begin(9600);
// }

// void loop() {
//   valorLuminosidade = analogRead(PINO_SENSOR_LDR);

//   float voltagem = valorLuminosidade * (5.0 / 1023.0);
//   if (voltagem > 4.98) voltagem = 4.98;

//   float resistencia = (5.0 * 10000.0 / voltagem) - 10000.0;
//   /* O método pow calcula a potência, separando os valores por vírgula */
//   float lux = 500.0 * pow((resistencia / 1000.0), -1.4); 

//   float ppfd = lux * PPFD_fator;

//   Serial.println(ppfd);
  
//   delay(2000);
// }

const int pinoSensor = A0; 

// Configurações do seu hardware
const float VTS = 5.0;             // Tensão de entrada do Arduino (5V)
const float R_FIXO = 10000.0;      // Resistor do divisor de tensão (10k ohms)

// Fator de conversão de Lux para PPFD (MUDE CONFORME SUA LUZ)
// Sol = 0.0185 | LED = 0.015 | Fluorescente = 0.0135
const float FATOR_PPFD = 0.0150; 

void setup() {
  Serial.begin(9600);
}

void loop() {
  int valorlido = analogRead(pinoSensor);

  // Evita divisão por zero caso o sensor leia o máximo
  if (valorlido == 1023) valorlido = 1022; 
  if (valorlido == 0) valorlido = 1;

  // 1. Converter lido para Volts
  float tensao = valorlido * (VTS / 1023.0);

  // 2. Calcular a resistência do LDR
  float rLdr = R_FIXO * ((VTS / tensao) - 1.0);

  // 3. Estimar o valor em Lux
  // Transforma a resistência em kOhms para a fórmula
  float rLdr_kOhm = rLdr / 1000.0;
  float lux = 500.0 / rLdr_kOhm;

  // 4. Converter Lux para estimativa de PPFD
  float ppfd = lux * FATOR_PPFD;

  // Imprimir os resultados
  Serial.print("Valor lido padrão: ");
  Serial.print(valorlido);
  Serial.print(" | Lux (est.): ");
  Serial.print(lux, 1);
  Serial.print(" | PPFD (est.): ");
  Serial.println(ppfd, 2);

  delay(1000); // Aguarda 1 segundo
}