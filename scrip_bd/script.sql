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
fkempresa INT,
CONSTRAINT chfkempresaestufa
FOREIGN KEY (fkempresa) REFERENCES empresa (idempresa)
);

CREATE TABLE sensor(
idsensor INT PRIMARY KEY AUTO_INCREMENT,
nome_sensor VARCHAR(255),
status_sensor TINYINT,
dt_instalação DATETIME,
dt_atualização DATETIME,
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


-- Comandos para criar o usuario user_insert e conceder as permissões
CREATE USER 'user_insert'@'%' IDENTIFIED BY 'Sptech#2024';
GRANT INSERT ON datalumini.* TO 'user_insert'@'%';
FLUSH PRIVILEGES;
