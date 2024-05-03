use ProjetoCinema
CREATE TABLE Fornecedor (
  CNPJ CHAR(14) PRIMARY KEY NOT NULL,
  razao_social CHAR(40) NOT NULL,
  CEP CHAR(8) NOT NULL,
  telefone NUMERIC(14, 0) NOT NULL,
  email VARCHAR(80) NOT NULL
);


CREATE TABLE Alimento (
  codigo NUMERIC(6,0) PRIMARY KEY NOT NULL,
  nome CHAR(40) NOT NULL,
  valor_unitario NUMERIC(7,2) NOT NULL,
  qtd_estoque INT NOT NULL
);


CREATE TABLE Fornece (
  CNPJ CHAR(14) NOT NULL,
  codigoAlimento NUMERIC(6,0) NOT NULL,
  valor NUMERIC(10, 2) NOT NULL,


  PRIMARY KEY (CNPJ, codigoAlimento),
  FOREIGN KEY (CNPJ) REFERENCES Fornecedor (CNPJ),
  FOREIGN KEY (codigoAlimento) REFERENCES Alimento (codigo)
);


CREATE TABLE Funcionario (
  carteira_de_trabalho NUMERIC(11,0) PRIMARY KEY NOT NULL,
  nome CHAR(50) NOT NULL,
  data_admissao DATE NOT NULL,
  salario NUMERIC(10, 2) NOT NULL,
  tipo INT NOT NULL
);




CREATE TABLE Atendente (
  carteira_de_trabalho NUMERIC(11,0) PRIMARY KEY NOT NULL,
  FOREIGN KEY (carteira_de_trabalho) REFERENCES Funcionario (carteira_de_trabalho)
);


CREATE TABLE Auxiliar_de_Limpeza (
  carteira_de_trabalho NUMERIC(11,0) PRIMARY KEY NOT NULL,
  FOREIGN KEY (carteira_de_trabalho) REFERENCES Funcionario (carteira_de_trabalho)
);


CREATE TABLE Tecnico_de_Manutencao (
  carteira_de_trabalho NUMERIC(11,0) PRIMARY KEY NOT NULL,
  FOREIGN KEY (carteira_de_trabalho) REFERENCES Funcionario (carteira_de_trabalho)
);


CREATE TABLE Sala (
  numero INT PRIMARY KEY NOT NULL,
  tipo CHAR(20) NOT NULL,
  capacidade INT NOT NULL,
  -- removido assento_disponivel INT NOT NULL e colocado em Sessao
);


CREATE TABLE ServicoLimpeza (
  carteira_de_trabalho NUMERIC(11,0) NOT NULL,
  numeroSala INT NOT NULL,
  data DATE NOT NULL,
  hora_inicio TIME NOT NULL,


  PRIMARY KEY (carteira_de_trabalho, numeroSala, data, hora_inicio),
  FOREIGN KEY (carteira_de_trabalho) REFERENCES Auxiliar_de_Limpeza (carteira_de_trabalho),
  FOREIGN KEY (numeroSala) REFERENCES Sala (numero)
);


CREATE TABLE Servico_Manutencao (
  carteira_de_trabalho NUMERIC(11,0) NOT NULL,
  numeroSala INT NOT NULL,
  data DATE NOT NULL,
  hora_inicio TIME NOT NULL,


  PRIMARY KEY (carteira_de_trabalho, numeroSala, data, hora_inicio),
  FOREIGN KEY (carteira_de_trabalho) REFERENCES Tecnico_de_Manutencao (carteira_de_trabalho),
  FOREIGN KEY (numeroSala) REFERENCES Sala (numero)
);


CREATE TABLE Filme (
  codigo NUMERIC(6,0) PRIMARY KEY NOT NULL,
  nome_portugues VARCHAR(80) NOT NULL,
  nome_original VARCHAR(80) NOT NULL,
  diretor VARCHAR(80) NOT NULL,
  data_lancamento DATE NOT NULL,
  genero VARCHAR(30) NOT NULL,
  classificacao_indicativa VARCHAR(10) NOT NULL,
  sinopse VARCHAR(200) NOT NULL,
  duracao_filme INT NOT NULL
);


CREATE TABLE Cliente (
  CPF CHAR(11) PRIMARY KEY NOT NULL,
  nome VARCHAR(100) NOT NULL,
  data_nascimento DATE NOT NULL,
  email VARCHAR(100) NOT NULL
);


CREATE TABLE Avaliacao (
  CPF_cliente CHAR(11) NOT NULL,
  codigoFilme NUMERIC(6,0) NOT NULL,
  nota NUMERIC(2, 1) NOT NULL,
  descricao VARCHAR(400),


  PRIMARY KEY (CPF_cliente, codigoFilme),
  FOREIGN KEY (CPF_cliente) REFERENCES Cliente (CPF),
  FOREIGN KEY (codigoFilme) REFERENCES Filme (codigo)
);


CREATE TABLE VendaAlimento (
  codigo_da_venda NUMERIC(6,0) PRIMARY KEY NOT NULL,
  carteira_de_trabalho NUMERIC(11,0) NOT NULL,
  CPF_cliente CHAR(11) NOT NULL,
  data DATETIME NOT NULL,
  FOREIGN KEY (carteira_de_trabalho) REFERENCES Atendente (carteira_de_trabalho),
  FOREIGN KEY (CPF_cliente) REFERENCES Cliente (CPF)
);




CREATE TABLE Compoe (
  codigoAlimento NUMERIC(6,0) NOT NULL,
  codigoVenda NUMERIC(6,0) NOT NULL,
  quantidade NUMERIC(3, 0) NOT NULL,


  PRIMARY KEY(codigoAlimento, codigoVenda),
  FOREIGN KEY (codigoAlimento) REFERENCES Alimento (codigo),
  FOREIGN KEY (codigoVenda) REFERENCES VendaAlimento (codigo_da_venda)
);


CREATE TABLE Sessao (
  codigo_sessao NUMERIC(6,0) NOT NULL,
  numeroSala INT NOT NULL,
  codigoFilme NUMERIC(6,0) NOT NULL,
  hora_de_inicio TIME NOT NULL CHECK (hora_de_inicio IN ('14:00', '14:30', '16:30', '18:00', '19:30', '20:00', '22:00', '00:00')),
  data DATE NOT NULL,
  qtd_assentos_disponiveis INT NOT NULL,




  PRIMARY KEY(codigo_sessao),
  UNIQUE(numeroSala, hora_de_inicio, data),
  FOREIGN KEY (numeroSala) REFERENCES Sala (numero),
  FOREIGN KEY (codigoFilme) REFERENCES Filme (codigo)
);


CREATE TABLE Ingresso (
  codigo_da_compra NUMERIC(6,0) PRIMARY KEY NOT NULL,
  CPF_cliente CHAR(11) NOT NULL,
  codigoSessao NUMERIC(6,0) NOT NULL,
  data DATE NOT NULL,
  hora TIME NOT NULL,
  modalidade_meia BIT NOT NULL,
  valor_pago DECIMAL(10, 2) NOT NULL,
  FOREIGN KEY (CPF_cliente) REFERENCES Cliente (CPF),
  FOREIGN KEY (codigoSessao) REFERENCES Sessao (codigo_sessao)
);


CREATE TABLE VendaIngresso (
  carteira_de_trabalho NUMERIC(11,0) NOT NULL,
  codigoCompra NUMERIC(6,0) NOT NULL,


  PRIMARY KEY(carteira_de_trabalho, codigoCompra),
  FOREIGN KEY (carteira_de_trabalho) REFERENCES Atendente (carteira_de_trabalho),
  FOREIGN KEY (codigoCompra) REFERENCES Ingresso (codigo_da_compra)
);


CREATE TABLE Premiacao (
id int IDENTITY(1,1) NOT NULL PRIMARY KEY,
nome_premio varchar(80) NOT NULL,
codigoFilme numeric(6,0) NOT NULL,


FOREIGN KEY (codigoFilme) REFERENCES Filme
)




/*Criando indices somente para chaves estrangeiras*/
CREATE INDEX idx_fk_carteira_trabalho_venda_alimento
ON VendaAlimento (carteira_de_trabalho);


CREATE INDEX idx_fk_cpfcli_venda_alimento
ON VendaAlimento (CPF_cliente);


CREATE INDEX idx_fk_numero_sala_sessao
ON Sessao (numeroSala);


CREATE INDEX idx_fk_codigo_filme_sessao
ON Sessao (codigoFilme);


CREATE INDEX idx_fk_codigoFilme_premiacao
ON Premiacao (codigoFilme);


CREATE INDEX idx_fk_cpfcli_ingresso
ON Ingresso (CPF_Cliente);


CREATE INDEX idx_fk_codigosessao_ingresso
ON Ingresso (codigoSessao);
