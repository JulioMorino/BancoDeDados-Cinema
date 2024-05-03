use ProjetoCinema
/*EXECs para testar o banco*/


/*
FORNECEDOR
*/
EXEC cadastro_fornecedor 12345436123456, 'Cia dos Alimentos LTDA', '14077830','019932345678','gerencia@ciadosalimentos.com'

EXEC cadastro_fornecedor
  @cnpj = '12345678901234',
  @razao_social = 'Fornecedor A',
  @cep = '12345678',
  @telefone = 1234567890,
  @email = 'fornecedor_a@example.com';


EXEC cadastro_fornecedor
  @cnpj = '56789012345678',
  @razao_social = 'Fornecedor B',
  @cep = '98765432',
  @telefone = 9876543210,
  @email = 'fornecedor_b@example.com';

SELECT * FROM Fornecedor

/*
Alimentos
*/

EXEC cadastrar_alimento
  @codigo_alimento = 100001,
  @nome_alimento = 'Pipoca',
  @valor_unitario = 10.50,
  @qtd_estoque = 50;


EXEC cadastrar_alimento
  @codigo_alimento = 100002,
  @nome_alimento = 'Refrigerante Lata',
  @valor_unitario = 5.00,
  @qtd_estoque = 100;


EXEC cadastrar_alimento
  @codigo_alimento = 100003,
  @nome_alimento = 'Garrafa de agua',
  @valor_unitario = 4.00,
  @qtd_estoque = 30;


EXEC cadastrar_alimento
  @codigo_alimento = 100004,
  @nome_alimento = 'Barra de Chocolate',
  @valor_unitario = 3.75,
  @qtd_estoque = 80;


EXEC cadastrar_alimento
  @codigo_alimento = 100005,
  @nome_alimento = 'Cachorro-Quente',
  @valor_unitario = 8.00,
  @qtd_estoque = 40;

SELECT * FROM Alimento


/*
Clientes
*/
EXEC cadastrar_cliente '12345678901', 'Maria Silva', '1995-03-12', 'maria@email.com';
EXEC cadastrar_cliente '98765432109', 'João Pereira', '1990-07-18', 'joao@email.com';
EXEC cadastrar_cliente '55555555555', 'Ana Souza', '1998-06-25', 'ana@email.com';
EXEC cadastrar_cliente '77777777777', 'Pedro Lima', '1997-11-03', 'pedro@email.com';
SELECT * FROM Cliente




/*
Funcionarios
*/
EXEC cadastrar_funcionario 12345678999, 'Jorge da Silva', '2020-10-15', 2100, 3
EXEC cadastrar_funcionario 88345678944, 'AAAAA AAAAAAAA', '2021-11-18', 2200, 3
EXEC cadastrar_funcionario 12345678993, 'Teixeira Ramos', '2020-10-22', 1800, 1
EXEC cadastrar_funcionario 72545678991, 'Alice Prado de Oliveira', '2020-11-27', 1950, 1
EXEC cadastrar_funcionario 93345678992, 'Fabio Xiang', '2020-10-22', 2300, 2
EXEC cadastrar_funcionario 72745678979, 'EEEEEEE EEEEEEEE', '2020-10-22', 1900, 2
EXEC cadastrar_funcionario 62345678981, 'Ibrahim Moizos', '2020-10-22', 1900, 2
SELECT * FROM Funcionario
SELECT * FROM Atendente
SELECT * FROM Auxiliar_de_Limpeza
SELECT * FROM Tecnico_de_Manutencao



/*
Salas
*/
EXEC cadastrar_sala 1, 'Regular 2d', 150
EXEC cadastrar_sala 2, 'Regular 2d', 150
EXEC cadastrar_sala 3, 'IMAX', 180
EXEC cadastrar_sala 4, 'IMAX', 180
EXEC cadastrar_sala 5, 'Regular 3d', 150
EXEC cadastrar_sala 6, 'Regular 3d', 150
EXEC cadastrar_sala 7, 'Regular 2d', 150
EXEC cadastrar_sala 8, 'IMAX', 180
EXEC cadastrar_sala 9, 'VIP', 90
SELECT * FROM Sala



/*
Registrar Limpezas
*/
EXEC registrar_limpeza_realizada 62345678981, 1, '2023-10-17', '14:35:28'
EXEC registrar_limpeza_realizada 62345678981, 1, '2023-10-17', '19:25:11'
EXEC registrar_limpeza_realizada 62345678981, 1, '2023-10-17', '21:50:40'


SELECT * FROM ServicoLimpeza

/*
Buscar limpezas ainda pendentes em uma determinada sala
*/
EXEC salas_nao_limpas_na_data --sem parametros, irá capturar data atual



/*
Registrar Manutenções
*/
EXEC registrar_manutencao_realizada 12345678999, 3, '2023-10-01', '11:23:48'
EXEC registrar_manutencao_realizada 12345678999, 5, '2023-10-01', '18:23:48'
EXEC registrar_manutencao_realizada 88345678944, 9, '2023-10-15', '12:25:33'
SELECT * FROM Servico_Manutencao



/*
Registrar fornecimento de alimentos
*/
EXEC fornece_alimento 12345436123456, 100002, 700.5, 100
EXEC fornece_alimento 12345436123456, 100001, 500.97, 220
EXEC fornece_alimento 56789012345678, 100004, 850, 200
SELECT * FROM Fornece


/*
Cadastrar venda
*/
EXEC cadastrar_vendaAlimento 1, 12345678993, 55555555555, '2023-10-18T18:10:32'
EXEC cadastrar_vendaAlimento 2, 12345678993, 12345678901, '2023-08-15T14:10:03'
EXEC cadastrar_vendaAlimento 3, 72545678991, 77777777777, '2023-10-11T18:30:35'

SELECT * FROM Atendente
SELECT * FROM Cliente
SELECT * FROM VendaAlimento

SELECT codigo_da_venda, VendaAlimento.carteira_de_trabalho, nome, salario, tipo 
from VendaAlimento INNER JOIN Atendente
	on VendaAlimento.carteira_de_trabalho = Atendente.carteira_de_trabalho
	INNER JOIN Funcionario
	ON Atendente.carteira_de_trabalho = Funcionario.carteira_de_trabalho

	
/*
Cadastrar itens da venda
*/
EXEC cadastrar_compoeVenda 100001, 1, 5
EXEC cadastrar_compoeVenda 100003, 1, 2
EXEC cadastrar_compoeVenda 100001, 2, 45
EXEC cadastrar_compoeVenda 100002, 2, 3
EXEC cadastrar_compoeVenda 100003, 2, 1
EXEC cadastrar_compoeVenda 100003, 3, 20
SELECT * FROM Alimento
SELECT * FROM Compoe
SELECT * FROM VendaAlimento


/*
Cadastrar filmes
*/
EXEC cadastrar_filme 1, 'O Senhor dos Anéis: A Sociedade do Anel', 'The Lord of the Rings: The Fellowship of the Ring', 'Peter Jackson', '2001-12-19', 'Fantasia', '12', 'Um anel para todos governar e no escuro achá-los. Na Terra de Mordor onde as Sombras se deitam. Na Terra de Mordor onde as Sombras se deitam.', 'Um filme incrível de fantasia', 178
EXEC cadastrar_filme 2, 'Interestelar', 'Interstellar', 'Christopher Nolan', '2014-11-06', 'Ficção Científica', '10', 'Explorando o espaço e o tempo para encontrar um novo lar para a humanidade.', 'Jornada espacial emocionante', 169
EXEC cadastrar_filme 3, 'Matrix', 'The Matrix', 'Lana Wachowski e Lilly Wachowski', '1999-04-08', 'Ação e Ficção Científica', '14', 'Realidade virtual e rebelião em um mundo dominado por máquinas.', 'Clássico da ficção científica', 136
EXEC cadastrar_filme 4, 'Os Vingadores', 'The Avengers', 'Joss Whedon', '2012-04-11', 'Ação e Super-heróis', '10', 'Os super-heróis da Marvel se unem para salvar o mundo de uma ameaça alienígena.', 'Ação épica com super-heróis', 143
EXEC cadastrar_filme 5, 'O Poderoso Chefão', 'The Godfather', 'Francis Ford Coppola', '1972-03-24', 'Crime e Drama', '16', 'A saga de uma família de mafiosos ítalo-americanos.', 'Um clássico do cinema', 175
EXEC cadastrar_filme 6, 'O Rei Leão', 'The Lion King', 'Roger Allers e Rob Minkoff', '1994-06-15', 'Animação e Aventura', 'Livre', 'A jornada de Simba, um jovem leão, para reclamar seu lugar como rei da Selva.', 'Uma história emocionante', 88
EXEC cadastrar_filme 7, 'Star Wars: Uma Nova Esperança', 'Star Wars: Episode IV - A New Hope', 'George Lucas', '1977-05-25', 'Ação e Ficção Científica', 'Livre', 'A jornada de Luke Skywalker contra o Império Galáctico.', 'Um épico espacial', 121
EXEC cadastrar_filme 8, 'Os Incríveis', 'The Incredibles', 'Brad Bird', '2004-10-27', 'Animação e Super-heróis', 'Livre', 'A vida de uma família de super-heróis que tenta levar uma vida normal.', 'Animação divertida', 115
EXEC cadastrar_filme 9, 'Jurassic Park', 'Jurassic Park', 'Steven Spielberg', '1993-06-11', 'Aventura e Ficção Científica', '10', 'Um parque de dinossauros que sai do controle.', 'Aventura com dinossauros', 127
EXEC cadastrar_filme 10, 'E.T. - O Extraterrestre', 'E.T. the Extra-Terrestrial', 'Steven Spielberg', '1982-06-11', 'Aventura e Ficção Científica', 'Livre', 'A história de amizade entre um menino e um alienígena perdido na Terra.', 'Um clássico emocionante', 115

SELECT * FROM Filme


/*
Cadastrar Sessoes
*/
EXEC cadastrar_sessao 100, 1, 6, '14:30:00', '2023-10-16', 150
EXEC cadastrar_sessao 102, 1, 6, '16:30:00', '2023-10-16', 150
EXEC cadastrar_sessao 103, 5, 10, '22:00:00', '2023-10-16', 150
EXEC cadastrar_sessao 104, 5, 4, '00:00:00', '2012-04-11', 150
EXEC cadastrar_sessao 105, 3, 4, '14:30:00', '2012-04-11', 150
EXEC cadastrar_sessao 106, 8, 2, '14:30:00', '2014-11-06', 180
EXEC cadastrar_sessao 107, 8, 2, '18:00:00', '2014-11-06', 180

SELECT * FROM Sessao
SELECT * FROM Sala



/*
EXEC sp_helpindex 'Sessao';

ALTER TABLE Sessao
DROP CONSTRAINT UQ_Sessao_UniqueKey;


ALTER TABLE Sessao
ADD CONSTRAINT UQ_Sessao_UniqueKey UNIQUE (numeroSala, data, hora_de_inicio);
*/


/*
Testando procedimento que verifica quantos assentos estão livres em uma sessao
*/
declare @retorno int
exec @retorno = verifica_assentos_sessao 100
print @retorno


/*
Cadastrar compras de Ingresso feitas pelo Cliente, sem Atendente intermediando
*/

EXEC compra_ingresso_cliente 1000, 55555555555, 102, '2023-10-16', '16:15:48', 0, 25
EXEC compra_ingresso_cliente 1001, 55555555555, 102, '2023-10-16', '16:15:48', 1, 25
EXEC compra_ingresso_cliente 1002, 77777777777, 103, '2023-10-16', '16:15:48'

EXEC compra_ingresso_cliente 1003, 77777777777, 106, '2014-11-06', '13:15:28', 0, 25
EXEC compra_ingresso_cliente 1004, 77777777777, 106, '2014-11-06', '13:15:28', 0, 25
EXEC compra_ingresso_cliente 1005, 77777777777, 106, '2014-11-06', '13:15:28', 0, 25
EXEC compra_ingresso_cliente 1006, 55555555555, 106, '2014-11-06', '13:15:28', 0, 25
EXEC compra_ingresso_cliente 1007, 55555555555, 106, '2014-11-06', '14:14:58', 0, 25
EXEC compra_ingresso_cliente 1007, 55555555555, 106, '2014-11-06', '14:14:58', 0, 25

EXEC compra_ingresso_cliente 1008, 12345678901, 107, '2014-11-06', '17:14:58', 1, 25
EXEC compra_ingresso_cliente 1009, 12345678901, 107, '2014-11-06', '17:14:58', 0, 25
EXEC compra_ingresso_cliente 1010, 12345678901, 107, '2014-11-06', '17:14:58', 1, 25

EXEC compra_ingresso_cliente 1011, 12345678901, 104, '2012-04-11', '17:14:58', 1, 25
EXEC compra_ingresso_cliente 1012, 12345678901, 104, '2012-04-11', '17:14:58', 0, 25
EXEC compra_ingresso_cliente 1013, 12345678901, 104, '2012-04-11', '17:14:58', 0, 25

SELECT * FROM Cliente
SELECT * FROM Filme
SELECT * FROM Sessao
SELECT * FROM Ingresso
SELECT * FROM visao_filme_e_lucroObtido

/*
Associar um atendente a uma compra de ingresso que foi feita presencialmente
*/
exec registra_venda_ingresso 12345678993, 1000
exec registra_venda_ingresso 12345678993, 1001

SELECT * FROM VendaIngresso


-- MOSTRA TODAS VENDAS REALIZADAS POR ATENDENTE, COM NULL PARA OS QUE AINDA NÃO VENDERAM
SELECT VendaIngresso.carteira_de_trabalho, VendaIngresso.codigoCompra, Funcionario.nome 
FROM VendaIngresso RIGHT JOIN Atendente
	ON VendaIngresso.carteira_de_trabalho = Atendente.carteira_de_trabalho
	INNER JOIN Funcionario
		ON Atendente.carteira_de_trabalho = Funcionario.carteira_de_trabalho

/*
Registrando avaliação de um Filme feita por Cliente
*/
SELECT * FROM Filme
SELECT * FROM Cliente

EXEC cadastrar_avaliacao_filme 77777777777, 6, 4.6, NULL
EXEC cadastrar_avaliacao_filme 12345678901, 6, 0, NULL
EXEC cadastrar_avaliacao_filme 77777777777, 4, 5, NULL
EXEC cadastrar_avaliacao_filme 12345678901, 4, 0, 'aaaaaaaa'
EXEC cadastrar_avaliacao_filme 12345678901, 1, 5, ':)'
EXEC cadastrar_avaliacao_filme 98765432109, 4, 5, 'llllllll'
EXEC cadastrar_avaliacao_filme 55555555555, 4, 5, NULL
EXEC cadastrar_avaliacao_filme 55555555555, 3, 5, NULL
EXEC cadastrar_avaliacao_filme 77777777777, 3, 5, NULL

SELECT * FROM Avaliacao


/*
Testando busca da media de um filme
*/
EXEC busca_media_filme Matrix
EXEC busca_media_filme Mat
EXEC busca_media_filme 