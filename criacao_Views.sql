use ProjetoCinema
go

/*
CRIAÇÃO DAS VIEWS
*/
/*Obtem informações sobre as sessoes do cinema*/
CREATE VIEW vw_SessoesFilmes AS
SELECT S.codigo_sessao, S.numeroSala, S.codigoFilme, S.hora_de_inicio, S.data,
       SA.tipo AS tipo_sala, F.nome_portugues AS nome_filme
FROM Sessao S
JOIN Sala SA ON S.numeroSala = SA.numero
JOIN Filme F ON S.codigoFilme = F.codigo

go
SELECT * FROM vw_SessoesFilmes


go
/*Obtem alimentos na bomboniere e informa Fornecedor responsável por esse abastecimento*/
CREATE VIEW vw_AlimentosEstoque AS
SELECT A.codigo, A.nome, A.valor_unitario, A.qtd_estoque, forn.razao_social AS 'Fornecido por'
FROM Alimento A
LEFT JOIN Fornece F ON A.codigo = F.codigoAlimento
LEFT JOIN Fornecedor forn ON F.CNPJ = forn.CNPJ

go
SELECT * FROM vw_AlimentosEstoque

go
/*Obtem filmes assistidos pelos clientes*/
CREATE VIEW vw_ClientesCompras AS
SELECT MIN(I.codigo_da_compra) codigo_da_compra, I.CPF_cliente, C.nome AS nome_cliente, I.codigoSessao,
       F.nome_portugues AS filme_assistido
FROM Ingresso I
JOIN Cliente C ON I.CPF_cliente = C.CPF
JOIN Sessao S  ON S.codigo_sessao = I.codigoSessao
JOIN Filme F   ON F.codigo = S.codigoFilme
GROUP BY I.CPF_cliente, C.nome, I.codigoSessao, F.nome_portugues


go
SELECT * FROM vw_ClientesCompras

go
/*Apresenta lucro obtido dos filmes*/
CREATE VIEW visao_filme_e_lucroObtido
AS
SELECT Sessao.codigoFilme, SUM (Ingresso.valor_pago) 'Lucro obtido'
FROM Sessao INNER JOIN Ingresso
	ON Ingresso.codigoSessao = Sessao.codigo_sessao
GROUP BY Sessao.codigoFilme


go
/*Obtem todos filmes, com suas medias de avaliacao*/
CREATE VIEW visao_nota_media_filme
AS
SELECT Avaliacao.codigoFilme, Filme.nome_portugues, AVG(Avaliacao.nota) 'Nota média'
FROM Avaliacao INNER JOIN Filme
	on Avaliacao.codigoFilme = Filme.codigo
GROUP BY Avaliacao.codigoFilme, Filme.nome_portugues

go
select * from visao_nota_media_filme


go
/*Obtem funcionarios do Cinema*/
CREATE VIEW vw_InformacoesFuncionario AS
SELECT F.carteira_de_trabalho, F.nome, F.data_admissao, F.salario, F.tipo,
       A.carteira_de_trabalho AS Atendente,
       AL.carteira_de_trabalho AS 'Auxiliar de Limpeza',
       TM.carteira_de_trabalho AS 'Técnico de Manutenção'
FROM Funcionario F
LEFT JOIN Atendente A ON F.carteira_de_trabalho = A.carteira_de_trabalho
LEFT JOIN Auxiliar_de_Limpeza AL ON F.carteira_de_trabalho = AL.carteira_de_trabalho
LEFT JOIN Tecnico_de_Manutencao TM ON F.carteira_de_trabalho = TM.carteira_de_trabalho

go
SELECT * FROM vw_InformacoesFuncionario

go
/*Obtem serviços de manutençao e carteira do técnico responsável*/
CREATE VIEW vw_ServicosManutencaoSala AS
SELECT SM.carteira_de_trabalho, SM.numeroSala, SM.data, SM.hora_inicio,
       S.tipo AS tipo_sala, S.capacidade
FROM Servico_Manutencao SM
JOIN Sala S ON SM.numeroSala = S.numero

go
SELECT * FROM vw_ServicosManutencaoSala

go
/*Obtem serviços de limpeza e a carteira do funcionário que a realizou*/
CREATE VIEW vw_ServicosLimpezaSala AS
SELECT SL.carteira_de_trabalho, SL.numeroSala, SL.data, SL.hora_inicio,
       S.tipo AS tipo_sala, S.capacidade
FROM ServicoLimpeza SL
JOIN Sala S ON SL.numeroSala = S.numero

go
SELECT * FROM vw_ServicosLimpezaSala

go
/*informações dos fornecedores que já realizaram entregas para o cinema*/
CREATE VIEW vw_InformacoesFornecedor AS
SELECT F.CNPJ, F.razao_social, F.CEP, F.telefone, F.email,
       FF.codigoAlimento, FF.valor
FROM Fornecedor F
JOIN Fornece FF ON F.CNPJ = FF.CNPJ

go
select * from Fornecedor
select * from Fornece
select * from vw_InformacoesFornecedor
