--Trigger para Atualizar Estoque de Alimentos após Venda: (disparar ao adicionar campo na tabela Compoe)

CREATE OR REPLACE FUNCTION atualiza_estoque_alimento()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Alimento
    SET qtd_estoque = qtd_estoque - NEW.quantidade
    WHERE codigo = NEW.codigoAlimento;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualiza_estoque_alimento
AFTER INSERT ON Compoe
FOR EACH ROW
EXECUTE FUNCTION atualiza_estoque_alimento();

--Trigger para Adicionar Premiação a um Filme se a Avaliação for Superior a 8.0 (disparar ao adicionar campo na tabela Avaliacao)

CREATE OR REPLACE FUNCTION adiciona_premiacao_filme()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.nota > 8.0 THEN
        UPDATE Filme
        SET premiacao = 'Melhor Avaliação'
        WHERE codigo = NEW.codigoFilme;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_adiciona_premiacao_filme
AFTER INSERT ON Avaliacao
FOR EACH ROW
EXECUTE FUNCTION adiciona_premiacao_filme();

--Trigger para atualizar a capacidade da sala após uma nova sessão

CREATE OR REPLACE FUNCTION atualiza_capacidade_sala()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Sala
    SET capacidade = capacidade - 1
    WHERE numero = NEW.numeroSala;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualiza_capacidade_sala
AFTER INSERT ON Sessao
FOR EACH ROW
EXECUTE FUNCTION atualiza_capacidade_sala();

-- Trigger para atualizar a data da última manutenção da sala após um serviço de manutenção

CREATE OR REPLACE FUNCTION atualiza_data_ultima_manutencao_sala()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE Sala
    SET data_ultima_manutencao = NEW.data
    WHERE numero = NEW.numeroSala;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_atualiza_data_ultima_manutencao_sala
AFTER INSERT ON Servico_Manutencao
FOR EACH ROW
EXECUTE FUNCTION atualiza_data_ultima_manutencao_sala();




