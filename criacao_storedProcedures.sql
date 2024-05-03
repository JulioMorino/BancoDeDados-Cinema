use ProjetoCinema
go
/*Cadastro de clientes*/
CREATE PROCEDURE cadastrar_cliente
@cpf char(11),
@nome_cliente varchar(100),
@data_nascimento date,
@email varchar(100)
AS
INSERT INTO Cliente
VALUES (@cpf, @nome_cliente, @data_nascimento, @email)


go
/*Cadastro de Funcionarios*/
CREATE PROCEDURE cadastrar_funcionario
@carteira_trabalho numeric(11,0),
@nome_funcionario char(50),
@data_admissao date,
@salario numeric(10,2),
@tipo int -- 1 para Atendente, 2 para Auxiliar de Limpeza, 3 para Técnico de Manutenção
AS
BEGIN TRAN
INSERT INTO Funcionario
VALUES (@carteira_trabalho, @nome_funcionario, @data_admissao, @salario, @tipo)
IF @@ROWCOUNT > 0
BEGIN
    IF @tipo = 1
    BEGIN
        INSERT INTO Atendente
        VALUES (@carteira_trabalho)
        COMMIT
        RETURN 0
    END
    ELSE IF @tipo = 2
    BEGIN
        INSERT INTO Auxiliar_de_Limpeza
        VALUES (@carteira_trabalho)
        COMMIT
        RETURN 0
    END
    ELSE IF @tipo = 3
    BEGIN
        INSERT INTO Tecnico_de_Manutencao
        VALUES (@carteira_trabalho)
        COMMIT
        RETURN 0
    END


    ELSE
    BEGIN
        PRINT 'Tipo de funcionario invalido';
        ROLLBACK
        RETURN 1
    END
END
ELSE
BEGIN
    ROLLBACK
    RETURN 1
END



go
/*Cadastro de salas do cinema*/
CREATE PROCEDURE cadastrar_sala
@numero_sala int,
@tipo char(20),
@capacidade int
AS
INSERT INTO Sala
VALUES (@numero_sala, @tipo, @capacidade)



go
/*Registro de Servico_Limpeza.PRÉ-REQUISITO: Auxiliar_de_Limpeza e Sala já inseridos no banco*/
CREATE PROCEDURE registrar_limpeza_realizada
@carteira_trabalho_limpeza numeric(11,0),
@numeroSala int,
@data_limpeza date,
@hora_limpeza time
AS




INSERT INTO ServicoLimpeza
VALUES (@carteira_trabalho_limpeza, @numeroSala, @data_limpeza, @hora_limpeza)



go
/*Busca salas que não receberam limpezas em uma determinada data*/
CREATE PROCEDURE salas_nao_limpas_na_data
@data_desejada date = NULL
AS
IF @data_desejada = NULL
BEGIN
    SET @data_desejada = GETDATE()
END
SELECT Sala.numero, ServicoLimpeza.numeroSala
FROM Sala LEFT JOIN ServicoLimpeza  
    ON Sala.numero = ServicoLimpeza.numeroSala AND ServicoLimpeza.data = @data_desejada
WHERE ServicoLimpeza.numeroSala IS NULL



go
/*Registro de Servico_Manutencao.PRÉ-REQUISITO: Tecnico_de_Manutencao e Sala já inseridos no banco*/
CREATE PROCEDURE registrar_manutencao_realizada
@carteira_trabalho_tecnico numeric(11,0),
@numeroSala int,
@data_manutencao date,
@hora_manutencao time
AS
INSERT INTO Servico_Manutencao
VALUES (@carteira_trabalho_tecnico, @numeroSala, @data_manutencao, @hora_manutencao)



go
/*Cadastro de fornecedores de alimentos*/
CREATE PROCEDURE cadastro_fornecedor
@cnpj char(14),
@razao_social char(40),
@cep char(8),
@telefone numeric(14,0),
@email varchar(80)
AS
INSERT INTO Fornecedor
VALUES (@cnpj, @razao_social, @cep, @telefone, @email)





go
/*Inserção de alimentos no estoque do cinema*/
CREATE PROCEDURE cadastrar_alimento
@codigo_alimento numeric(6,0),
@nome_alimento char(40),
@valor_unitario numeric(7,2),
@qtd_estoque int
AS
INSERT INTO Alimento
VALUES (@codigo_alimento, @nome_alimento, @valor_unitario, @qtd_estoque)



go
/*Fornecimento de alimentos e atualização do estoque. PRÉ-REQUISITO: Fornecedor e Alimento já inseridos no banco*/
CREATE PROCEDURE fornece_alimento
@cnpj_fornecedor char(14),
@codigoAlimento numeric(6,0),
@valor_fornecimento numeric(10,2),
@qtd_fornecida int
AS
BEGIN TRAN
IF @qtd_fornecida <= 0
BEGIN
    PRINT 'Quantidade fornecida inválida.'
    ROLLBACK
    RETURN 1
END
ELSE
BEGIN
    INSERT INTO Fornece
    VALUES (@cnpj_fornecedor, @codigoAlimento, @valor_fornecimento)
    IF @@ROWCOUNT > 0
    BEGIN
        UPDATE Alimento
        SET qtd_estoque = qtd_estoque + @qtd_fornecida
        WHERE codigo = @codigoAlimento
        IF @@ROWCOUNT > 0
        BEGIN
            COMMIT
            RETURN 0
        END
        ELSE
        BEGIN
            ROLLBACK
            RETURN 1
        END
    END
    ELSE
    BEGIN
        ROLLBACK
        RETURN 1
    END
END



go
/*Cadastrar venda de alimento. PRÉ-REQUISITO: Cliente e Atendente já inseridos no banco.*/
CREATE PROCEDURE cadastrar_vendaAlimento
@codigo_da_venda numeric(6,0),
@carteira_trabalho_atendente numeric(11,0),
@cpf_cliente char(11),
@data_venda datetime
AS
INSERT INTO VendaAlimento
VALUES (@codigo_da_venda, @carteira_trabalho_atendente, @cpf_cliente, @data_venda)



go
/*Verificar a disponibilidade de determinado alimento no estoque. PRÉ-REQUISITO: Alimento já inserido no banco*/
CREATE PROCEDURE verifica_estoque_disponivel
@codigoAlimento numeric(6,0),
@quantidade_solicitada numeric(3,0)
AS
DECLARE @quantidade_disponivel numeric(3,0)
DECLARE @nome_alimento char(40)


SELECT @quantidade_disponivel = qtd_estoque, @nome_alimento = nome
FROM Alimento
WHERE codigo = @codigoAlimento
IF @quantidade_solicitada > @quantidade_disponivel
BEGIN
    DECLARE @alerta_estoque varchar(200)
    SET @alerta_estoque = 'Estoque insuficiente de: ' + @nome_alimento
    RAISERROR(@alerta_estoque, 16, 1)
    RETURN 1
END
ELSE
BEGIN
    IF @quantidade_disponivel < 10
    BEGIN
        PRINT 'Estoque proximo do fim: ' + @nome_alimento
    END


    RETURN 0
END


go
/*Cadastrar itens de uma determinada venda de alimentos e atualizar o estoque. PRÉ-REQUISITO: Venda e Alimento já inseridos no banco; PROCEDURE verifica_estoque_disponivel já criado.*/
CREATE PROCEDURE cadastrar_compoeVenda
@codigoAlimento numeric(6,0),
@codigoVenda numeric(6,0),
@quantidade_vendida numeric(3,0)
AS
BEGIN TRAN
DECLARE @retorno int -- 0 => disponivel, 1 => estoque em falta
EXEC @retorno = verifica_estoque_disponivel @codigoAlimento, @quantidade_vendida
IF @retorno = 0
BEGIN
    INSERT INTO Compoe
    VALUES (@codigoAlimento, @codigoVenda, @quantidade_vendida)
    IF @@ROWCOUNT > 0
    BEGIN
        UPDATE Alimento
        SET qtd_estoque = qtd_estoque - @quantidade_vendida
        WHERE codigo = @codigoAlimento
        IF @@ROWCOUNT > 0
        BEGIN
            COMMIT
            RETURN 0
        END
        ELSE
        BEGIN
            ROLLBACK
            RETURN 1
        END
    END
    ELSE
    BEGIN
        ROLLBACK
        RETURN 1
    END
END
ELSE
BEGIN
    ROLLBACK
    RETURN 1
END



go
/*Inserção de filmes no cartaz*/
CREATE PROCEDURE cadastrar_filme
@codigo_filme numeric(6,0),
@nome_portugues varchar(80),
@nome_original varchar(80),
@diretor varchar(80),
@data_lancamento date,
@genero varchar(30),
@classificacao_indicativa varchar(10),
@sinopse varchar(200),
@premiacao varchar(80),
@duracao_minutos_filme int
AS
INSERT INTO Filme
VALUES (@codigo_filme, @nome_portugues, @nome_original, @diretor, @data_lancamento, @genero, @classificacao_indicativa, @sinopse, @premiacao, @duracao_minutos_filme)



go
/*Cadastro de Sessões no cinema. PRÉ-REQUISITO: ter Filme e Sala já inseridos no banco*/
CREATE PROCEDURE cadastrar_sessao
@codigo_sessao numeric(6,0),
@numeroSala int,
@codigoFilme numeric(6,0),
@hora_de_inicio time,
@data date,
@qtd_assentos_disponiveis int
AS
BEGIN TRAN
DECLARE @capacidade_sala int
SELECT @capacidade_sala = capacidade
FROM Sala
WHERE numero = @numeroSala

IF @qtd_assentos_disponiveis > @capacidade_sala
BEGIN
    RAISERROR('Assentos disponiveis para a Sessao excedeu a capacidade maxima da Sala escolhida.', 16, 1)
    ROLLBACK
    RETURN 1
END
ELSE
BEGIN
    INSERT INTO Sessao
    VALUES (@codigo_sessao, @numeroSala, @codigoFilme, @hora_de_inicio, @data, @qtd_assentos_disponiveis)
    IF @@ROWCOUNT > 0
    BEGIN
        COMMIT
        RETURN 0
    END
    ELSE
    BEGIN
        ROLLBACK
        RETURN 1
    END
END


go
/*verificando assentos ainda disponiveis em uma determinada sessao.
PRÉ-REQUISITO: Sessao já inserida no banco*/
CREATE PROCEDURE verifica_assentos_sessao
@codigoSessao numeric (6,0)
AS
DECLARE @qtd_assentos_livres int
SELECT @qtd_assentos_livres = qtd_assentos_disponiveis
FROM Sessao
WHERE codigo_sessao = @codigoSessao


RETURN @qtd_assentos_livres


go
/*Compra de ingresso feita pelo Cliente (não intermediada por atendente), verificando disponibilidade da sessão e atualizando os lugares disponíveis nessa determinada sessão.
PRÉ-REQUISITO: Cliente e Sessão já inseridos no banco*/
CREATE PROCEDURE compra_ingresso_cliente
@codigo_da_compra numeric(6,0),
@CPF_cliente char(11),
@codigoSessao numeric(6,0),
@data date,
@hora time,
@modalidade_meia bit,
@valor_pago decimal(10,2)
AS
BEGIN TRAN
DECLARE @qtd_assentos_disponiveis int
exec @qtd_assentos_disponiveis = verifica_assentos_sessao @codigoSessao


IF @qtd_assentos_disponiveis > 0
BEGIN
    IF @modalidade_meia = 1
    BEGIN
        SET @valor_pago = @valor_pago / 2
    END


    INSERT INTO Ingresso
    VALUES (@codigo_da_compra, @CPF_cliente, @codigoSessao, @data, @hora, @modalidade_meia, @valor_pago)


    IF @@ROWCOUNT > 0
    BEGIN --atualizar assentos disponiveis na sessao
        UPDATE Sessao
        SET qtd_assentos_disponiveis = qtd_assentos_disponiveis - 1
        WHERE codigo_sessao = @codigoSessao
        IF @@ROWCOUNT > 0
        BEGIN
            COMMIT
            RETURN 0
        END
        ELSE
        BEGIN
            ROLLBACK
            RETURN 1
        END
    END
    ELSE
    BEGIN
        ROLLBACK
        RETURN 1
    END
END
ELSE
BEGIN
    RAISERROR('Sessao esgotada', 16, 1)
    ROLLBACK
    RETURN 1
END

go
/*Registrar venda de ingresso que foi feita presencialmente pelo Atendente, verificando disponibilidade da sessão e atualizando os lugares disponíveis nessa determinada sala. 
PRÉ-REQUISITO: Atendente e Ingresso já inseridos no banco*/
CREATE PROCEDURE registra_venda_ingresso
@carteira_de_trabalho_atendente numeric(11,0),
@codigoCompra numeric(6,0)
AS
INSERT INTO VendaIngresso
VALUES (@carteira_de_trabalho_atendente, @codigoCompra)


go
/*Registro de avaliação feita por um cliente de um determinado filme. 
PRÉ-REQUISITO: Cliente e Filme já inseridos no banco*/
CREATE PROCEDURE cadastrar_avaliacao_filme
@cpf char(11),
@codigoFilme_avaliado numeric(6,0),
@nota numeric(2,1),
@descricao varchar(400)
AS
INSERT INTO Avaliacao
VALUES (@cpf, @codigoFilme_avaliado, @nota, @descricao)

go
/*Informar a media de um determinado filme no banco.
PRÉ-REQUISITO: visao_nota_media_filme já criada no banco*/
CREATE PROCEDURE busca_media_filme
@nome_filme_desejado varchar(80)= '%'
AS
SET @nome_filme_desejado = '%' + @nome_filme_desejado + '%';
SELECT *
FROM visao_nota_media_filme
WHERE nome_portugues like @nome_filme_desejado
