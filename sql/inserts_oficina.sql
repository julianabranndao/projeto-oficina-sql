USE oficina;
START TRANSACTION;

-- Inclusão da base de Clientes
INSERT INTO clientes (nome,email,telefone,tipo) VALUES
 ('Ana Souza','ana@ex.com','11999990001','PF'),
 ('Bruno Lima','bruno@ex.com','11999990002','PF'),
 ('Carla Nunes','carla@ex.com','21999990003','PF'),
 ('Diego Alves','diego@ex.com','31999990004','PF'),
 ('Oficina Parceira Ltda','contato@parceira.com','1133334444','PJ'),
 ('Translog Transportes','financeiro@translog.com','1144445555','PJ');

INSERT INTO cliente_pf (idCliente,cpf,dtNasc,cep,logradouro,numero,complemento) VALUES
 (1,'12345678901','1990-04-10','04567000','Rua Alfa','100','Ap 12'),
 (2,'23456789012','1987-08-22','04000000','Av. Beta','200',NULL),
 (3,'34567890123','1995-12-05','03000000','Rua Gama','55','Fundos'),
 (4,'45678901234','1980-02-28','02000000','Al. Delta','88',NULL);

INSERT INTO cliente_pj (idCliente,cnpj,inscrEstadual,cep,logradouro,numero,complemento) VALUES
 (5,'11222333000199','IS123','09000000','Rua Industrial','500',NULL),
 (6,'99888777000166','IS789','09100000','Av. Logística','1200','Bloco B');

-- Veículos (cada um de um cliente)
INSERT INTO veiculo (idCliente,placa,marca,modelo,ano,cor,combustivel) VALUES
 (1,'ABC1D23','Honda','Civic',2018,'Prata','Flex'),
 (2,'DEF4G56','VW','Gol',2014,'Branco','Flex'),
 (3,'HIJ7K89','Fiat','Toro',2022,'Preto','Diesel'),
 (4,'LMN0P12','Toyota','Corolla',2019,'Cinza','Flex'),
 (5,'QRS3T45','MB','Sprinter',2017,'Branco','Diesel'),
 (6,'UVW6X78','VW','Constellation',2020,'Azul','Diesel');

-- Mecânicos
INSERT INTO mecanico (nome,cpf,especialidade,valorHora,telefone) VALUES
 ('Marcos Pereira','11122233344','Motor/Freios',120,'11988887777'),
 ('Juliana Costa','22233344455','Elétrica/Diagnóstico',140,'11977776666'),
 ('Rafael Dias','33344455566','Suspensão/Alinhamento',110,'11966665555');

-- Serviços catálogo
INSERT INTO servico_catalogo (descricao,precoBase,tempoEstimadoMin) VALUES
 ('Troca de Óleo', 120.00, 40),
 ('Revisão 10k',   450.00, 180),
 ('Pastilha de Freio (eixo)', 220.00, 90),
 ('Alinhamento e Balanceamento', 150.00, 60);

-- Peças e fornecedor
INSERT INTO peca (descricao,unidade,precoUnit,estoque) VALUES
 ('Óleo 5W30 1L','L',55.00,80),
 ('Filtro de Óleo','UN',35.00,40),
 ('Pastilha Dianteira - Civic','JOGO',320.00,12),
 ('Pastilha Dianteira - Corolla','JOGO',300.00,10);

INSERT INTO fornecedor (razaoSocial,cnpj,contato,telefone) VALUES
 ('AutoParts Brasil','10203040000155','vendas@autoparts.com','1140403030'),
 ('Freios Master','20304050000111','contato@freiosmaster.com','1135355050');

INSERT INTO peca_fornecedor (idFornecedor,idPeca,precoCompra) VALUES
 (1,1,38.00),(1,2,22.00),(2,3,240.00),(2,4,230.00);

-- Duas OS: uma de PF e uma PJ
INSERT INTO ordem_servico (idCliente,idVeiculo,km,status,observacoes) VALUES
 (1,1,45000,'Em_Execucao','Revisão + troca de óleo'),
 (5,5,180000,'Aguardando_Pecas','Sprinter com ruído de freio');

-- Itens de serviço
INSERT INTO os_item_servico (idOS,idServico,qtde,precoUnit,desconto) VALUES
 (1,1,1,120.00,0.00),
 (1,2,1,450.00,50.00),
 (2,3,1,220.00,0.00);

-- Itens de peça
INSERT INTO os_item_peca (idOS,idPeca,qtde,precoUnit,desconto) VALUES
 (1,1,4,55.00,0.00),      -- 4 litros de óleo
 (1,2,1,35.00,0.00),
 (2,3,1,320.00,0.00);

-- Alocação de mecânicos
INSERT INTO os_mecanico (idOS,idMecanico,horas,valorHora) VALUES
 (1,1,2.5,120.00),
 (1,2,1.0,140.00),
 (2,1,0.5,120.00),
 (2,3,1.5,110.00);

-- Pagamento (apenas OS 1 concluída financeiramente)
INSERT INTO pagamento (idOS,forma,status,valor,dataPagto) VALUES
 (1,'Cartao','Pago', 120+450-50 + (4*55)+35 + (2.5*120)+(1*140), NOW());

COMMIT;