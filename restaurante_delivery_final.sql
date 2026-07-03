CREATE TABLE `Cliente` (
  `id_cliente` int PRIMARY KEY AUTO_INCREMENT,
  `nome` varchar(255),
  `email` varchar(255),
  `CPF` varchar(255),
  `data_cad` date
);

CREATE TABLE `Endereco` (
  `id_endereco` int PRIMARY KEY AUTO_INCREMENT,
  `logradouro` varchar(255),
  `numero` varchar(255),
  `bairro` varchar(255),
  `CEP` varchar(255),
  `complemento` varchar(255),
  `id_cliente` int
);

CREATE TABLE `Telefone_Cliente` (
  `id_cliente` int,
  `telefone` varchar(255),
  PRIMARY KEY (`id_cliente`, `telefone`)
);

CREATE TABLE `Categoria` (
  `id_categ` int PRIMARY KEY AUTO_INCREMENT,
  `nome` varchar(255),
  `descricao` text
);

CREATE TABLE `Produto` (
  `id_prod` int PRIMARY KEY AUTO_INCREMENT,
  `nome` varchar(255),
  `descricao` text,
  `preco` decimal(10,2),
  `disponivel` boolean,
  `id_categ` int
);

CREATE TABLE `Pedido` (
  `id_pedido` int PRIMARY KEY AUTO_INCREMENT,
  `status_pedido` varchar(255),
  `data_hora` datetime,
  `descricao` text,
  `id_cliente` int,
  `id_func_atendente` int
);

CREATE TABLE `Item_Pedido` (
  `id_pedido` int,
  `id_prod` int,
  `quantidade` int,
  `preco_unit` decimal(10,2),
  `observacao` text,
  PRIMARY KEY (`id_pedido`, `id_prod`)
);

CREATE TABLE `Pagamento` (
  `id_pagamento` int PRIMARY KEY AUTO_INCREMENT,
  `metodo` varchar(255),
  `status_pagamento` varchar(255),
  `valor` decimal(10,2),
  `data_hora` datetime,
  `id_pedido` int
);

CREATE TABLE `Avaliacao` (
  `id_aval` int PRIMARY KEY AUTO_INCREMENT,
  `nota` int,
  `comentario` text,
  `data_hora` datetime,
  `id_pedido` int
);

CREATE TABLE `Funcionario` (
  `id_func` int PRIMARY KEY AUTO_INCREMENT,
  `nome` varchar(255),
  `cargo` varchar(255),
  `data_adm` date,
  `cpf` varchar(255),
  `data_deslig` date,
  `ativo` boolean
);

CREATE TABLE `Telefone_Funcionario` (
  `id_func` int,
  `telefone` varchar(255),
  PRIMARY KEY (`id_func`, `telefone`)
);

CREATE TABLE `Atendente` (
  `id_func` int PRIMARY KEY
);

CREATE TABLE `Cozinheiro` (
  `id_func` int PRIMARY KEY,
  `especialidade` varchar(255)
);

CREATE TABLE `Entregador` (
  `id_func` int PRIMARY KEY,
  `disponivel` boolean
);

CREATE TABLE `Veiculo` (
  `id_veiculo` int PRIMARY KEY AUTO_INCREMENT,
  `tipo` varchar(255),
  `placa` varchar(255),
  `marca` varchar(255),
  `modelo` varchar(255),
  `ano` int
);

CREATE TABLE `Entregador_veiculo` (
  `id_veiculo` int,
  `id_func_entregador` int,
  PRIMARY KEY (`id_func_entregador`, `id_veiculo`)
);

CREATE TABLE `Entrega` (
  `id_entrega` int PRIMARY KEY AUTO_INCREMENT,
  `hora_saida` datetime,
  `hora_entrega` datetime,
  `status_entrega` varchar(255),
  `id_pedido` int,
  `id_func_entregador` int
);

CREATE TABLE `Prepara_Cozinheiro` (
  `id_func_cozinheiro` int,
  `id_pedido` int,
  PRIMARY KEY (`id_func_cozinheiro`, `id_pedido`)
);

-- FOREIGN KEYS

ALTER TABLE `Endereco` ADD FOREIGN KEY (`id_cliente`) REFERENCES `Cliente` (`id_cliente`);

ALTER TABLE `Telefone_Cliente` ADD FOREIGN KEY (`id_cliente`) REFERENCES `Cliente` (`id_cliente`);

ALTER TABLE `Produto` ADD FOREIGN KEY (`id_categ`) REFERENCES `Categoria` (`id_categ`);

ALTER TABLE `Pedido` ADD FOREIGN KEY (`id_cliente`) REFERENCES `Cliente` (`id_cliente`);

ALTER TABLE `Pedido` ADD FOREIGN KEY (`id_func_atendente`) REFERENCES `Atendente` (`id_func`);

ALTER TABLE `Item_Pedido` ADD FOREIGN KEY (`id_pedido`) REFERENCES `Pedido` (`id_pedido`);

ALTER TABLE `Item_Pedido` ADD FOREIGN KEY (`id_prod`) REFERENCES `Produto` (`id_prod`);

ALTER TABLE `Pagamento` ADD FOREIGN KEY (`id_pedido`) REFERENCES `Pedido` (`id_pedido`);

ALTER TABLE `Avaliacao` ADD FOREIGN KEY (`id_pedido`) REFERENCES `Pedido` (`id_pedido`);
ALTER TABLE `Telefone_Funcionario` ADD FOREIGN KEY (`id_func`) REFERENCES `Funcionario` (`id_func`);

ALTER TABLE `Atendente` ADD FOREIGN KEY (`id_func`) REFERENCES `Funcionario` (`id_func`);

ALTER TABLE `Cozinheiro` ADD FOREIGN KEY (`id_func`) REFERENCES `Funcionario` (`id_func`);

ALTER TABLE `Entregador` ADD FOREIGN KEY (`id_func`) REFERENCES `Funcionario` (`id_func`);

ALTER TABLE `Entregador_veiculo` ADD FOREIGN KEY (`id_func_entregador`) REFERENCES `Entregador` (`id_func`);

ALTER TABLE `Entregador_veiculo` ADD FOREIGN KEY (`id_veiculo`) REFERENCES `Veiculo` (`id_veiculo`);

ALTER TABLE `Entrega` ADD FOREIGN KEY (`id_pedido`) REFERENCES `Pedido` (`id_pedido`);

ALTER TABLE `Entrega` ADD FOREIGN KEY (`id_func_entregador`) REFERENCES `Entregador` (`id_func`);

ALTER TABLE `Prepara_Cozinheiro` ADD FOREIGN KEY (`id_func_cozinheiro`) REFERENCES `Cozinheiro` (`id_func`);

ALTER TABLE `Prepara_Cozinheiro` ADD FOREIGN KEY (`id_pedido`) REFERENCES `Pedido` (`id_pedido`);
