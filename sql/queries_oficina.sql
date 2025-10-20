USE oficina;

-- Total de OS por cliente
SELECT c.idCliente, c.nome, COUNT(*) AS total_os
FROM ordem_servico os
JOIN clientes c ON c.idCliente = os.idCliente
GROUP BY c.idCliente, c.nome
ORDER BY total_os DESC, c.nome;

-- Receita por OS (serviços + peças + horas), com detalhamento
SELECT
  os.idOS,
  c.nome AS cliente,
  SUM(COALESCE( (ois.qtde*ois.precoUnit) - ois.desconto ,0)) +
  SUM(COALESCE( (oip.qtde*oip.precoUnit) - oip.desconto ,0)) +
  SUM(COALESCE( (osm.horas*osm.valorHora) ,0)) AS valor_bruto
FROM ordem_servico os
JOIN clientes c ON c.idCliente = os.idCliente
LEFT JOIN os_item_servico ois ON ois.idOS = os.idOS
LEFT JOIN os_item_peca    oip ON oip.idOS = os.idOS
LEFT JOIN os_mecanico     osm ON osm.idOS = os.idOS
GROUP BY os.idOS, c.nome
ORDER BY os.idOS;

-- Top serviços por faturamento (considerando itens lançados)
SELECT sc.descricao,
       ROUND(SUM((ois.qtde*ois.precoUnit) - ois.desconto),2) AS faturamento
FROM os_item_servico ois
JOIN servico_catalogo sc ON sc.idServico = ois.idServico
GROUP BY sc.descricao
ORDER BY faturamento DESC;

-- Mecânicos com mais horas alocadas (mínimo 1h) - HAVING
SELECT m.nome, SUM(osm.horas) AS horas_trabalhadas
FROM os_mecanico osm
JOIN mecanico m ON m.idMecanico = osm.idMecanico
GROUP BY m.nome
HAVING SUM(osm.horas) >= 1
ORDER BY horas_trabalhadas DESC;

-- Veículos com maior gasto (somatório itens + horas)
SELECT v.placa, v.modelo,
       ROUND(SUM(COALESCE(ois.qtde*ois.precoUnit - ois.desconto,0) +
                 COALESCE(oip.qtde*oip.precoUnit - oip.desconto,0) +
                 COALESCE(osm.horas*osm.valorHora,0)),2) AS total_gasto
FROM ordem_servico os
JOIN veiculo v ON v.idVeiculo = os.idVeiculo
LEFT JOIN os_item_servico ois ON ois.idOS = os.idOS
LEFT JOIN os_item_peca    oip ON oip.idOS = os.idOS
LEFT JOIN os_mecanico     osm ON osm.idOS = os.idOS
GROUP BY v.placa, v.modelo
ORDER BY total_gasto DESC;

-- Estoque baixo de peças - com classificação via CASE
SELECT p.idPeca, p.descricao, p.estoque,
       CASE
         WHEN p.estoque = 0 THEN 'Sem estoque'
         WHEN p.estoque < 10 THEN 'Baixo'
         WHEN p.estoque BETWEEN 10 AND 30 THEN 'Adequado'
         ELSE 'Alto'
       END AS nivel_estoque
FROM peca p
ORDER BY p.estoque ASC;

-- Fornecedores que também são clientes PJ (mesmo CNPJ)
SELECT f.razaoSocial, f.cnpj
FROM fornecedor f
JOIN cliente_pj pj ON pj.cnpj = f.cnpj;

-- OS aguardando peças com peças vinculadas
SELECT os.idOS, c.nome, os.status, GROUP_CONCAT(DISTINCT p.descricao ORDER BY p.descricao SEPARATOR ', ') AS pecas
FROM ordem_servico os
JOIN clientes c ON c.idCliente = os.idCliente
LEFT JOIN os_item_peca oip ON oip.idOS = os.idOS
LEFT JOIN peca p ON p.idPeca = oip.idPeca
WHERE os.status = 'Aguardando_Pecas'
GROUP BY os.idOS, c.nome, os.status;

-- Receita por mês (considerando data de pagamento)
SELECT DATE_FORMAT(p.dataPagto,'%Y-%m') AS ano_mes,
       ROUND(SUM(p.valor),2) AS receita
FROM pagamento p
WHERE p.status = 'Pago'
GROUP BY DATE_FORMAT(p.dataPagto,'%Y-%m')
ORDER BY ano_mes;

-- Ranking de clientes por faturamento (HAVING mínimo 1 OS paga)
SELECT c.idCliente, c.nome,
       ROUND(SUM(p.valor),2) AS total_pago,
       COUNT(p.idPagamento)  AS os_pagas
FROM clientes c
JOIN ordem_servico os ON os.idCliente = c.idCliente
JOIN pagamento p ON p.idOS = os.idOS AND p.status='Pago'
GROUP BY c.idCliente, c.nome
HAVING COUNT(p.idPagamento) >= 1
ORDER BY total_pago DESC;