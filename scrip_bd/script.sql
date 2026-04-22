-- banco de dados datalumini

CREATE DATABASE datalumini;

USE datalumini;

CREATE TABLE empresa (
idempresa INT PRIMARY KEY AUTO_INCREMENT,
razaosocial VARCHAR(255),
cnpj CHAR(11),
email VARCHAR(255),
responsavel_legal VARCHAR(255),
status_empresa TINYINT);

CREATE TABLE usuario(
idusuario INT PRIMARY KEY AUTO_INCREMENT,
email VARCHAR(255),
senha VARCHAR(255),
cpf CHAR(11),
fkempresa INT, 
CONSTRAINT chfkempresausuario
FOREIGN KEY (fkempresa) REFERENCES empresa (idempresa));

CREATE TABLE estufa (
idestufa INT PRIMARY KEY AUTO_INCREMENT,
nome_estufa VARCHAR(255),
status_estufa TINYINT,
limiteMaximo FLOAT,
limiteMinimo FLOAT,
fkempresa INT,
CONSTRAINT chfkempresaestufa
FOREIGN KEY (fkempresa) REFERENCES empresa (idempresa)
);

CREATE TABLE sensor(
idsensor INT PRIMARY KEY AUTO_INCREMENT,
nome_sensor VARCHAR(255),
status_sensor TINYINT,
dt_instalacao DATETIME,
dt_atualizacao DATETIME,
fkestufa INT,
CONSTRAINT chfkestufasensor 
FOREIGN KEY (fkestufa) REFERENCES estufa (idestufa));

CREATE TABLE leitura(
idleitura INT PRIMARY KEY AUTO_INCREMENT,
freq_luminosidade FLOAT,
dt_capt_dados DATETIME,
fksensor INT,
CONSTRAINT chsensorleitura
FOREIGN KEY (fksensor) REFERENCES sensor(idsensor));

CREATE TABLE log(
idLog INT PRIMARY KEY AUTO_INCREMENT,
dataHora DATETIME,
fkEstufa INT ,
fkUsuario INT,
CONSTRAINT ctFkEstufa 
FOREIGN KEY (fkEstufa)
REFERENCES estufa(idestufa),
CONSTRAINT ctFkUsuario
FOREIGN KEY (fkUsuario)
REFERENCES usuario(idusuario)
);

INSERT INTO empresa (razaosocial, cnpj, email, responsavel_legal, status_empresa) VALUES
('Laboratório de Biologia Vegetal USP', '11111111000', 'contato@lbvusp.br', 'Dra. Ana Ribeiro', 1),
('Centro de Pesquisa Genética Unicamp', '22222222000', 'suporte@geneticacamp.br', 'Dr. Lucas Martins', 1),
('Embrapa Recursos Genéticos e Biotecnologia', '11111111000', 'contato@embrapa.br', 'Dr. João Silva', 1),
('Instituto Agronômico de Campinas (IAC)', '55555555000', 'contato@iac.sp.gov.br', 'Dr. Rafael Costa', 1);

INSERT INTO usuario (email, senha, cpf, fkempresa) VALUES
('joao.silva@embrapa.br', 'embrapa123', '12345678901', 3),
('ana.ribeiro@usp.br', 'usp123', '34567890123', 1),
('carlos.lima@usp.br', 'usp456', '45678901234', 1),
('lucas.martins@unicamp.br', 'unicamp123', '56789012345', 2),
('maria.santos@iac.sp.gov.br', 'iac123', '89012345678', 4);

INSERT INTO estufa (nome_estufa, limiteMinimo,limiteMaximo, status_estufa,fkempresa) VALUES
('estufa EMBRAPA',100,200, 1, 3),
('estufa USP', 100,200, 1, 1),
('estufa UNICAMP', 100,200,1, 2),
('estufa IAC',100,200, 1, 4);


INSERT INTO sensor (nome_sensor, status_sensor, dt_instalacao, dt_atualizacao, fkestufa) VALUES
('Sensor A - EMBRAPA', 1, '2026-03-01 08:00:00', '2026-04-01 09:00:00', 1),
('Sensor B - USP', 1, '2026-03-02 09:00:00', '2026-04-01 09:20:00', 2),
('Sensor C - UNICAMP', 1, '2026-03-03 10:00:00', '2026-04-01 09:40:00', 3),
('sensor D - IAC', 1, '2026-03-05 12:00:00', '2026-04-01 10:10:00', 4);

INSERT INTO leitura (freq_luminosidade, dt_capt_dados, fksensor) VALUES
(110.5, '2026-04-01 09:00:00', 1),
(120.0, '2026-04-01 10:00:00', 1),
(130.2, '2026-04-01 11:00:00', 1),
(150.0, '2026-04-01 09:00:00', 2),
(160.4, '2026-04-01 10:00:00',2),
(180.3, '2026-04-01 09:00:00', 3),
(175.0, '2026-04-01 10:00:00', 3),
(400.0, '2026-04-01 09:00:00', 4),
(420.8, '2026-04-01 10:00:00', 4);

INSERT INTO log(dataHora, fkEstufa,fkUsuario) VALUES 
('2026-04-22 10:00:00', 1, 1 ),
('2026-04-21 15:23:00', 3, 4),
('2026-04-22 11:15:16', 2, 3);

SELECT 
    l.idleitura,
    l.freq_luminosidade,
    l.dt_capt_dados,
    s.nome_sensor,
    es.nome_estufa,
    e.razaosocial
FROM leitura l
JOIN sensor s 
    ON l.fksensor = s.idsensor
JOIN estufa es 
    ON s.fkestufa = es.idestufa
JOIN empresa e 
    ON es.fkempresa = e.idempresa;
    
    
    
    SELECT e.limiteminimo,
    e.limitemaximo,
    l.dt_capt_dados,
    l.freq_luminosidade,
    e.nome_estufa 
    FROM estufa e 
    JOIN sensor s 
    ON s.fkestufa = e.idestufa
    JOIN leitura l
    ON l.fksensor = s.idsensor;

    


-- Comandos para criar o usuario user_insert e conceder as permissões
CREATE USER 'user_insert'@'%' IDENTIFIED BY 'Sptech#2024';
GRANT INSERT ON datalumini.* TO 'user_insert'@'%';
FLUSH PRIVILEGES;
