

-- Comandos para criar o usuario user_insert e conceder as permissões
CREATE USER 'user_insert'@'%' IDENTIFIED BY 'Sptech#2024';
GRANT INSERT ON datalumini.* TO 'user_insert'@'%';
FLUSH PRIVILEGES;