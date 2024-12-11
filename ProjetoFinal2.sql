-- ____________________________________________BANCO DE DADOS_____________________________________________

-- Tabelas de Funcionários e Cargos
-- CREATE DATABASE TESTE02;

USE TESTE02;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Gerente;
DROP TABLE IF EXISTS Funcionarios;
DROP TABLE IF EXISTS Cargo;
DROP TABLE IF EXISTS JoiaFornecedor;
DROP TABLE IF EXISTS Brinco;
DROP TABLE IF EXISTS Colar;
DROP TABLE IF EXISTS Anel;
DROP TABLE IF EXISTS Joia;
DROP TABLE IF EXISTS Tipo;
DROP TABLE IF EXISTS Cliente;
DROP TABLE IF EXISTS Fornecedor;
DROP TABLE IF EXISTS PedidoJoia;
DROP TABLE IF EXISTS Pagamentos;
DROP TABLE IF EXISTS Pedidos;
SET FOREIGN_KEY_CHECKS = 1;



CREATE TABLE Cargo (
    CargoId INT AUTO_INCREMENT PRIMARY KEY,             
    descricao ENUM('Vendedor', 'Gerente') NOT NULL     
);

CREATE TABLE Funcionarios (
    id INT PRIMARY KEY AUTO_INCREMENT,     
    nome VARCHAR(100) NOT NULL,            
    nif VARCHAR(9) UNIQUE NOT NULL,        
    DataDeContratacao DATE NOT NULL,      
    CargoId INT NOT NULL,                           
    FOREIGN KEY (CargoId) REFERENCES Cargo(CargoId) 
);

CREATE TABLE Gerente (
    GerenteId INT PRIMARY KEY,             
    NumeroDeVendas INT NOT NULL,                    
    MetaDeVendas INT NOT NULL,                     
    FOREIGN KEY (GerenteId) REFERENCES Funcionarios(id)  
);

-- Tabelas de Joias e Tipos
CREATE TABLE Tipo (
    TipoId INT PRIMARY KEY AUTO_INCREMENT,  
    DescricaoJoia ENUM('Brinco', 'Anel', 'Colar') NOT NULL
);

CREATE TABLE Joia (
    JoiaId INT PRIMARY KEY AUTO_INCREMENT, 
    Nome VARCHAR(100) UNIQUE NOT NULL,                     
    TipoId INT NOT NULL,                          
    Material VARCHAR(50) NOT NULL,                  
    Peso DECIMAL(10, 2) NOT NULL,                   
    Preco DECIMAL(10, 2) NOT NULL,                  
    QuantidadeEmStock INT NOT NULL,                 
    Categoria ENUM('Luxo', 'Casual', 'Noivado') NOT NULL, 
    FOREIGN KEY (TipoId) REFERENCES Tipo(TipoId) 
);


CREATE TABLE Brinco (
    BrincoId INT AUTO_INCREMENT PRIMARY KEY,
    TipoDeFecho VARCHAR(100) NOT NULL,
    FOREIGN KEY (BrincoId) REFERENCES Joia(JoiaId)
);

CREATE TABLE Colar (
    ColarId INT AUTO_INCREMENT PRIMARY KEY,                
    Comprimento DECIMAL(10, 2) NOT NULL,             
    FOREIGN KEY (ColarId) REFERENCES Joia(JoiaId)
);

CREATE TABLE Anel (
    AnelId INT AUTO_INCREMENT PRIMARY KEY,                  
    Tamanho INT NOT NULL,                             
    FOREIGN KEY (AnelId) REFERENCES Joia(JoiaId)
);


CREATE TABLE Cliente (
    ClienteId INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    Nif VARCHAR(10) UNIQUE NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Contacto VARCHAR(20) NOT NULL,
    Endereco VARCHAR(100) NOT NULL
);

CREATE TABLE Fornecedor (
    FornecedorId INT AUTO_INCREMENT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    NumeroIva VARCHAR(100) Unique NOT NULL,
    Contacto VARCHAR(20) NOT NULL,
    Endereco VARCHAR(100) NOT NULL
);

CREATE TABLE JoiaFornecedor (
    JoiaId INT NOT NULL,
    FornecedorId INT NOT NULL,
    Quantidade INT NOT NULL,
    PRIMARY KEY (JoiaId, FornecedorId),
    FOREIGN KEY (JoiaId) REFERENCES Joia(JoiaId) ON DELETE CASCADE, 
    FOREIGN KEY (FornecedorId) REFERENCES Fornecedor(FornecedorId)
);

CREATE TABLE Pedidos (
    PedidosId INT AUTO_INCREMENT PRIMARY KEY,
    DataPedido DATE NOT NULL,
    ClienteId INT NOT NULL,
    ValorTotal DECIMAL(10, 2),
    Status ENUM('Entregue', 'Pago', 'Pendente', 'Cancelado') NOT NULL,
    FOREIGN KEY (ClienteId) REFERENCES Cliente(ClienteId)
);

CREATE TABLE PedidoJoia (
    PedidoId INT NOT NULL,
    JoiaId INT NOT NULL,
    Quantidade INT NOT NULL,
    PRIMARY KEY (PedidoId, JoiaId),
    FOREIGN KEY (PedidoId) REFERENCES Pedidos(PedidosId),
    FOREIGN KEY (JoiaId) REFERENCES Joia(JoiaId)
);

CREATE TABLE Pagamentos (
    PagamentoID INT AUTO_INCREMENT PRIMARY KEY,
    DataPagamento DATE NOT NULL,
    PedidoId INT NOT NULL,
    Valor DECIMAL(10, 2) NOT NULL,
    MetodoPagamento ENUM('CartaoDeCredito', 'TransferenciaBancaria', 'Dinheiro') NOT NULL,
    FOREIGN KEY (PedidoId) REFERENCES Pedidos(PedidosId)
);



-- ______________________PREENCHIMENTO DO BANCO DE DADOS COM DADOS DE AMOSTRA PARA TESTE__________________________-



INSERT IGNORE INTO Cargo (descricao) 
VALUES ('Gerente'), ('Vendedor');

INSERT INTO Funcionarios (nome, nif, DataDeContratacao, CargoId)
VALUES ('Hélvio Lourenço', '293060800', '2021-10-01', (SELECT CargoId FROM Cargo WHERE descricao = 'Gerente')), 
('Jorge Fraga', '234975080', '2022-12-11', (SELECT CargoId FROM Cargo WHERE descricao = 'Vendedor')), 
('Damasio Bernoulli', '245532970', '2022-01-01', (SELECT CargoId FROM Cargo WHERE descricao = 'Vendedor'));

INSERT INTO Gerente (GerenteId, NumeroDeVendas, MetaDeVendas)
VALUES ((SELECT id FROM Funcionarios WHERE nif = '293060800'), 0, 60);

INSERT IGNORE INTO Tipo (DescricaoJoia) 
VALUES ('Brinco'), ('Anel'),('Colar');

INSERT INTO Joia (Nome, TipoId, Material, Peso, Preco, QuantidadeEmStock, Categoria)
VALUES 
('Brinco de Ouro', (SELECT TipoId FROM Tipo WHERE DescricaoJoia = 'Brinco'), 'Ouro', 10.5, 500.00, 0, 'Luxo'),
('Colar de Prata', (SELECT TipoId FROM Tipo WHERE DescricaoJoia = 'Colar'), 'Prata', 15.2, 300.00, 0, 'Casual'),
('Anel de Diamante', (SELECT TipoId FROM Tipo WHERE DescricaoJoia = 'Anel'), 'Diamante', 5.0, 1000.00, 0, 'Noivado');


INSERT INTO Brinco (BrincoId, TipoDeFecho)
VALUES 
((SELECT JoiaId FROM Joia WHERE Nome = 'Brinco de Ouro'), 'Catalão');


INSERT INTO Colar (ColarId, Comprimento)
VALUES 
((SELECT JoiaId FROM Joia WHERE Nome = 'Colar de Prata'), 50);


INSERT INTO Anel (AnelId, Tamanho)
VALUES  ((SELECT JoiaId FROM Joia WHERE Nome = 'Anel de Diamante'), 12);


INSERT INTO Cliente (Nome, Nif, Email, Contacto, Endereco)
VALUES 
    ('Alice Martins', '123456789', 'alice.martins@gmail.com', '912345678', 'Lisboa 2311-312'),
    ('João Silva', '123451443', 'joao.silva@gmail.com', '934567890', 'Almada 4561-312'),
    ('Maria Sousa', '241541422', 'maria.sousa@gmail.com', '923456789', 'Cascais 2341-212');
    
     
INSERT INTO Fornecedor (Nome, NumeroIva, Contacto, Endereco)
VALUES 
    ('Fornecedor A', 'PT123456789', '912345678', 'Parque Empresarial, 101'),
    ('Fornecedor B', 'PT987654321', '934567890', 'Zona Industrial, 202');


INSERT INTO JoiaFornecedor (JoiaId, FornecedorId, Quantidade)
VALUES 
	((SELECT JoiaId FROM Joia WHERE Nome = 'Brinco de Ouro'), 1, 20), 
    ((SELECT JoiaId FROM Joia WHERE Nome = 'Colar de Prata'), 2, 25),
    ((SELECT JoiaId FROM Joia WHERE Nome = 'Anel de Diamante'), 2, 10);
    
    
INSERT INTO Pedidos (DataPedido, ClienteId, ValorTotal, Status)
VALUES 
('2024-12-01',(SELECT ClienteId FROM Cliente WHERE Nif = '123456789'), null , 'Pendente'),
('2024-12-02',(SELECT ClienteId FROM Cliente WHERE Nif = '123451443'), null , 'Pendente'),
('2024-12-03',(SELECT ClienteId FROM Cliente WHERE Nif = '241541422'), null , 'Pendente');


INSERT INTO PedidoJoia (PedidoId, JoiaId, Quantidade)
VALUES 
((SELECT PedidosId FROM Pedidos WHERE ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '123456789' ) ORDER BY PedidosId DESC Limit 1), 
 (SELECT JoiaId FROM Joia WHERE Nome = 'Brinco de Ouro'), 2), 
 
 ((SELECT PedidosId FROM Pedidos WHERE ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '123451443' ) ORDER BY PedidosId DESC Limit 1), 
 (SELECT JoiaId FROM Joia WHERE Nome = 'Colar de Prata'), 1), 
 
 ((SELECT PedidosId FROM Pedidos WHERE ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '241541422' ) ORDER BY PedidosId DESC Limit 1), 
 (SELECT JoiaId FROM Joia WHERE Nome = 'Anel de Diamante'), 3); 
 

 




-- ________________________________________________________UPDATES__________________________________________________________________
-- Atualizar o preco de uma Joia

UPDATE JoiaFornecedor
SET Quantidade = 30
WHERE JoiaId = (SELECT JoiaId FROM Joia WHERE Nome = 'Brinco de Ouro');


-- Atualizar o Stock apos receber Joias de Fornecedores

SET @JoiaId = (SELECT JoiaId FROM Joia WHERE Nome = 'Brinco de Ouro');
SET @Quantidade = (SELECT COALESCE ( SUM(Quantidade), 0) FROM JoiaFornecedor WHERE JoiaId = (SELECT JoiaId FROM Joia WHERE Nome = 'Brinco de Ouro'));
UPDATE Joia
SET QuantidadeEmStock = QuantidadeEmStock + @Quantidade
WHERE JoiaId = @JoiaId;

SET @JoiaId = (SELECT JoiaId FROM Joia WHERE Nome = 'Colar de Prata');
SET @Quantidade = (SELECT COALESCE ( SUM(Quantidade), 0) FROM JoiaFornecedor WHERE JoiaId = (SELECT JoiaId FROM Joia WHERE Nome = 'Colar de Prata'));
UPDATE Joia
SET QuantidadeEmStock = QuantidadeEmStock + @Quantidade
WHERE JoiaId = @JoiaId;

SET @JoiaId = (SELECT JoiaId FROM Joia WHERE Nome = 'Anel de Diamante');
SET @Quantidade = (SELECT COALESCE ( SUM(Quantidade), 0) FROM JoiaFornecedor WHERE JoiaId = (SELECT JoiaId FROM Joia WHERE Nome = 'Anel de Diamante'));
UPDATE Joia
SET QuantidadeEmStock = QuantidadeEmStock + @Quantidade
WHERE JoiaId = @JoiaId;



-- Atualizar a quantidade pedida em alguma encomenda

UPDATE PedidoJoia
SET Quantidade = 2
WHERE PedidoId = (SELECT PedidosId FROM Pedidos WHERE ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '123456789') AND DataPedido = '2024-12-01') 
AND JoiaId = (SELECT JoiaId FROM Joia WHERE Nome = 'Brinco de Ouro');



-- Atualizar o Stock apos alguma encomenda, feita de forma automatica

SET @JoiaId = (SELECT JoiaId FROM Joia WHERE Nome = 'Brinco de Ouro');
SET @Quantidade = (SELECT COALESCE(SUM(Quantidade), 0) FROM PedidoJoia WHERE JoiaId = (SELECT JoiaId FROM Joia WHERE Nome = 'Brinco de Ouro'));
UPDATE Joia
SET QuantidadeEmStock = QuantidadeEmStock - @Quantidade
WHERE JoiaId = @JoiaId;

SET @JoiaId = (SELECT JoiaId FROM Joia WHERE Nome = 'Colar de Prata');
SET @Quantidade = (SELECT COALESCE(SUM(Quantidade), 0) FROM PedidoJoia WHERE JoiaId = (SELECT JoiaId FROM Joia WHERE Nome = 'Colar de Prata'));
UPDATE Joia
SET QuantidadeEmStock = QuantidadeEmStock - @Quantidade
WHERE JoiaId = @JoiaId;

SET @JoiaId = (SELECT JoiaId FROM Joia WHERE Nome = 'Anel de Diamante');
SET @Quantidade = (SELECT COALESCE(SUM(Quantidade), 0) FROM PedidoJoia WHERE JoiaId = (SELECT JoiaId FROM Joia WHERE Nome = 'Anel de Diamante'));
UPDATE Joia
SET QuantidadeEmStock = QuantidadeEmStock - @Quantidade
WHERE JoiaId = @JoiaId;



-- Atualizar o total de Vendas Feitas

SET @Gerente = (SELECT GerenteId FROM Gerente);
SET @TotalPedidos = (SELECT COUNT(*) FROM Pedidos);
UPDATE Gerente
SET NumeroDeVendas = @TotalPedidos
WHERE GerenteId = @Gerente;



-- Atualizar o preco de uma Joia

UPDATE Joia
SET Preco = 1200.00
WHERE Nome = 'Anel de Diamante';

UPDATE Joia
SET Preco = 350.00
WHERE Nome = 'Colar de Prata';


-- Atualizar o estado de um Pedido

UPDATE Pedidos
SET Status = 'Entregue'
WHERE PedidosId IN (
    SELECT PedidoId
    FROM PedidoJoia
    WHERE JoiaId = (SELECT JoiaId FROM Joia WHERE Nome = 'Brinco de Ouro')
);



-- ____________________________________Exceção, esse metodo que é a continuação do preenchimento do banco de dados apenas está aqui para garantir que apos as atualizacoes
-- o valor do pedido assim como as quantidades estejam atualizadas.

-- Obs: atualiza a tabela de pedidos a cima, o campo do valor total que está como null, fiz isso porque precisava da quantidade que ainda nao tinha para multiplicar pelo preco da joia
SET @PedidoId = (SELECT PedidosId FROM Pedidos	WHERE ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '123456789') ORDER BY PedidosId DESC LIMIT 1);
UPDATE Pedidos
SET ValorTotal = (SELECT SUM(Joia.Preco * PedidoJoia.Quantidade)FROM Joia JOIN PedidoJoia ON Joia.JoiaId = PedidoJoia.JoiaId WHERE PedidoJoia.PedidoId = @PedidoId ) WHERE PedidosId = @PedidoId;
 
 SET @PedidoId1 = (SELECT PedidosId FROM Pedidos	WHERE ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '123451443') ORDER BY PedidosId DESC LIMIT 1);
UPDATE Pedidos
SET ValorTotal = (SELECT SUM(Joia.Preco * PedidoJoia.Quantidade)FROM Joia JOIN PedidoJoia ON Joia.JoiaId = PedidoJoia.JoiaId WHERE PedidoJoia.PedidoId = @PedidoId1 ) WHERE PedidosId = @PedidoId1;
 
 SET @PedidoId2 = (SELECT PedidosId FROM Pedidos	WHERE ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '241541422') ORDER BY PedidosId DESC LIMIT 1);
UPDATE Pedidos
SET ValorTotal = (SELECT SUM(Joia.Preco * PedidoJoia.Quantidade)FROM Joia JOIN PedidoJoia ON Joia.JoiaId = PedidoJoia.JoiaId WHERE PedidoJoia.PedidoId = @PedidoId2 ) WHERE PedidosId = @PedidoId2;
 
 
 
 
INSERT INTO Pagamentos (DataPagamento, PedidoId, Valor, MetodoPagamento)
VALUES 
('2024-12-01' , (SELECT PedidosId FROM Pedidos WHERE ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '123456789') ORDER BY PedidosId DESC Limit 1), 
(SELECT ValorTotal from Pedidos where ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '123456789')
 ORDER BY PedidosId DESC Limit 1), 'TransferenciaBancaria'),
 
 ('2024-12-02' , (SELECT PedidosId FROM Pedidos WHERE ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '123451443') ORDER BY PedidosId DESC Limit 1), 
(SELECT ValorTotal from Pedidos where ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '123451443')
 ORDER BY PedidosId DESC Limit 1), 'TransferenciaBancaria'),
 
 ('2024-12-03' , (SELECT PedidosId FROM Pedidos WHERE ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '241541422') ORDER BY PedidosId DESC Limit 1), 
(SELECT ValorTotal from Pedidos where ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '241541422')
 ORDER BY PedidosId DESC Limit 1), 'Dinheiro');







-- ________________________________________________________________REMOVE_______________________________________________________________

-- Aqui nessa parte tem alguns exemplos de Remove

DELETE FROM PedidoJoia
WHERE PedidoId = (SELECT PedidosId FROM Pedidos WHERE ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '241541422') AND DataPedido = '2024-12-03');

DELETE FROM Pagamentos
WHERE PedidoId = (SELECT PedidosId FROM Pedidos WHERE ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '241541422') AND DataPedido = '2024-12-03');

DELETE FROM Pedidos
WHERE ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '241541422') AND DataPedido = '2024-12-03';

DELETE FROM Cliente
WHERE Nif = '241541422';




     
-- _________________________________READ _______________________________________

-- Ver todos os pedidos de um cliente 
SELECT * FROM Pedidos
WHERE ClienteId = (SELECT ClienteId FROM Cliente WHERE Nif = '123456789');

-- ver a quantidade em stock de uma joia
SELECT Nome, QuantidadeEmStock
FROM Joia WHERE Nome = 'Brinco de Ouro';

-- ver todos os pedidos de um certo dia
SELECT * 
FROM Pedidos
WHERE DataPedido = '2024-12-01';

-- ver todas as categorias de joias de luxo
SELECT Nome, Material, Preco, QuantidadeEmStock
FROM Joia
WHERE Categoria = 'Luxo';

-- Ver todos os funcionarios e os seus cargos
SELECT Funcionarios.id, Funcionarios.nome, Funcionarios.nif, Cargo.descricao AS Cargo
FROM Funcionarios
JOIN Cargo ON Funcionarios.CargoId = Cargo.CargoId;












   -- SHOW TABLES;
--  SELECT * FROM Tipo;
 -- SELECT * FROM Joia;
 -- SELECT * FROM Pagamentos;
 -- SELECT * FROM Pedidos;
 -- SELECT * FROM PedidoJoia;
-- SELECT * FROM Brinco;
-- SELECT * FROM Colar;
-- SELECT * FROM Anel;
 -- SELECT * FROM Gerente;
 -- SELECT * FROM Cliente;

