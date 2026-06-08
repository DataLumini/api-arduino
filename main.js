// importa as bibliotecas necessárias
const serialport = require('serialport');
const express = require('express');
const mysql = require('mysql2');

// constantes para configurações
const SERIAL_BAUD_RATE = 9600;
const SERVIDOR_PORTA = 3300;

// habilita ou desabilita a inserção de dados no banco de dados
const HABILITAR_OPERACAO_INSERIR = true;

// função para comunicação serial
const serial = async (valoresSensorLuminosidade) => {
    let poolBancoDados = mysql.createPool({
        host: 'localhost',
        user: 'user_insert',
        password: 'Sptech#2024',
        database: 'datalumini',
        port: 3307
    }).promise();

    // lista as portas seriais disponíveis e procura pelo Arduino
    const portas = await serialport.SerialPort.list();
    const portaArduino = portas.find((porta) => porta.vendorId == 2341 && porta.productId == 43);

    if (!portaArduino) {
        throw new Error('O Arduino não foi encontrado em nenhuma porta serial');
    }

    // configura a porta serial com o baud rate especificado
    const arduino = new serialport.SerialPort({
        path: portaArduino.path,
        baudRate: SERIAL_BAUD_RATE
    });

    // evento quando a porta serial é aberta
    arduino.on('open', () => {
        console.log(`A leitura do Arduino foi iniciada na porta ${portaArduino.path} utilizando Baud Rate de ${SERIAL_BAUD_RATE}`);
    });

    // processa os dados recebidos do Arduino
    arduino.pipe(new serialport.ReadlineParser({ delimiter: '\r\n' })).on('data', async (data) => {
        console.log(`\nDado original recebido: ${data}`);
        const sensorLuminosidade = parseFloat(data);

        // Se não for um número válido, interrompe para não quebrar o código
        if (isNaN(sensorLuminosidade)) return;

        // Armazena no array da API e mantém apenas as últimas 20 leituras para não travar o servidor
        valoresSensorLuminosidade.push(sensorLuminosidade);
        if (valoresSensorLuminosidade.length > 20) {
            valoresSensorLuminosidade.shift();
        }

        if (HABILITAR_OPERACAO_INSERIR) {
            let valoresParaInserir = [];

            // Gera as 64 leituras simuladas com variação de +/- 25%
            for (let i = 0; i < 64; i++) {
                // Math.random() * 0.5 gera um número de 0.0 a 0.5
                // Somando 0.65, o multiplicador fica entre 0.65 (25% a menos) e 1.15 (25% a mais)
                let multiplicador = 0.65 + (Math.random() * 0.50);
                let novaQuantidade = Math.round(sensorLuminosidade * multiplicador);

                // Evita luminosidade negativa
                if (novaQuantidade < 0) novaQuantidade = 0;

                valoresParaInserir.push([novaQuantidade, i+1]);
            }

            await poolBancoDados.query(
                'INSERT INTO Leitura (frequenciaLuminosidade, fksensor) VALUES ?',
                [valoresParaInserir]
            );
            console.log(`${valoresParaInserir.length} leituras simuladas inseridas no banco.`);
        }
    });

    // evento para lidar com erros na comunicação serial
    arduino.on('error', (mensagem) => {
        console.error(`Erro na comunicação com o Arduino: ${mensagem}`);
    });
};

// função para criar e configurar o servidor web (API)
const servidor = (valoresSensorLuminosidade) => {
    const app = express();

    // configurações de CORS para permitir requisições do front-end
    app.use((request, response, next) => {
        response.header('Access-Control-Allow-Origin', '*');
        response.header('Access-Control-Allow-Headers', 'Origin, Content-Type, Accept');
        next();
    });

    // endpoint da API para retornar as últimas leituras
    app.get('/sensores/luminosidade', (_, response) => {
        return response.json(valoresSensorLuminosidade);
    });

    // inicia o servidor
    app.listen(SERVIDOR_PORTA, () => {
        console.log(`API executada com sucesso. Acesse http://localhost:${SERVIDOR_PORTA}/sensores/luminosidade`);
    });
};

(async () => {
    try {
        const valoresSensorLuminosidade = [];

        await serial(valoresSensorLuminosidade);

        // inicia o servidor web
        servidor(valoresSensorLuminosidade);

    } catch (erroGlobal) {
        console.error("Falha ao iniciar a aplicação:", erroGlobal.message);
    }
})();