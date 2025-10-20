-- Criando Tabelas Bases para Manipulação do BD de uma Oficina

DROP DATABASE IF EXISTS oficina;
CREATE DATABASE oficina
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_0900_ai_ci;
USE oficina;

-- Clientes PF/PJ 
CREATE TABLE clientes (
  idCliente INT AUTO_INCREMENT PRIMARY KEY,
  nome        VARCHAR(120) NOT NULL,
  email       VARCHAR(120) NOT NULL UNIQUE,
  telefone    VARCHAR(20),
  tipo        ENUM('PF','PJ') NOT NULL,
  createdAt   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cliente_pf (
  idCliente INT PRIMARY KEY,
  cpf       CHAR(11) NOT NULL UNIQUE,
  dtNasc    DATE NOT NULL,
  cep       CHAR(8) NOT NULL,
  logradouro VARCHAR(120) NOT NULL,
  numero    VARCHAR(10) NOT NULL,
  complemento VARCHAR(40),
  CONSTRAINT fk_cpf_client
    FOREIGN KEY (idCliente) REFERENCES clientes(idCliente)
      ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE cliente_pj (
  idCliente INT PRIMARY KEY,
  cnpj      CHAR(14) NOT NULL UNIQUE,
  inscrEstadual VARCHAR(30),
  cep       CHAR(8) NOT NULL,
  logradouro VARCHAR(120) NOT NULL,
  numero    VARCHAR(10) NOT NULL,
  complemento VARCHAR(40),
  CONSTRAINT fk_cpj_client
    FOREIGN KEY (idCliente) REFERENCES clientes(idCliente)
      ON UPDATE CASCADE ON DELETE CASCADE
);

-- Veículos
CREATE TABLE veiculo (
  idVeiculo INT AUTO_INCREMENT PRIMARY KEY,
  idCliente INT NOT NULL,
  placa     VARCHAR(8) NOT NULL UNIQUE,
  marca     VARCHAR(40) NOT NULL,
  modelo    VARCHAR(60) NOT NULL,
  ano       SMALLINT,
  cor       VARCHAR(20),
  chassi    VARCHAR(20),
  combustivel ENUM('Gasolina','Etanol','Diesel','Flex','GNV','Eletrico','Hibrido') DEFAULT 'Flex',
  CONSTRAINT fk_veic_cliente
    FOREIGN KEY (idCliente) REFERENCES clientes(idCliente)
      ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Mecânicos / Equipes
CREATE TABLE mecanico (
  idMecanico INT AUTO_INCREMENT PRIMARY KEY,
  nome        VARCHAR(120) NOT NULL,
  cpf         CHAR(11) UNIQUE,
  especialidade VARCHAR(80),
  valorHora   DECIMAL(10,2) NOT NULL DEFAULT 80.00,
  telefone    VARCHAR(20)
);

-- Catálogo de serviços e peças
CREATE TABLE servico_catalogo (
  idServico INT AUTO_INCREMENT PRIMARY KEY,
  descricao VARCHAR(120) NOT NULL,
  precoBase DECIMAL(10,2) NOT NULL CHECK (precoBase >= 0),
  tempoEstimadoMin SMALLINT
);

CREATE TABLE peca (
  idPeca INT AUTO_INCREMENT PRIMARY KEY,
  descricao VARCHAR(120) NOT NULL,
  unidade   ENUM('UN','L','KG','PAR','JOGO') DEFAULT 'UN',
  precoUnit DECIMAL(10,2) NOT NULL CHECK (precoUnit >= 0),
  estoque   INT NOT NULL DEFAULT 0 CHECK (estoque >= 0)
);

-- Fornecedores e vínculo peça-fornecedor
CREATE TABLE fornecedor (
  idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
  razaoSocial  VARCHAR(255) NOT NULL,
  cnpj         CHAR(14) UNIQUE,
  contato      VARCHAR(60),
  telefone     VARCHAR(20)
);

CREATE TABLE peca_fornecedor (
  idFornecedor INT NOT NULL,
  idPeca       INT NOT NULL,
  precoCompra  DECIMAL(10,2) NOT NULL CHECK (precoCompra >= 0),
  PRIMARY KEY (idFornecedor, idPeca),
  CONSTRAINT fk_pf_forn FOREIGN KEY (idFornecedor) REFERENCES fornecedor(idFornecedor)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_pf_peca FOREIGN KEY (idPeca) REFERENCES peca(idPeca)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Ordens de Serviço (OS)
CREATE TABLE ordem_servico (
  idOS        INT AUTO_INCREMENT PRIMARY KEY,
  idCliente   INT NOT NULL,
  idVeiculo   INT NOT NULL,
  km          INT,
  dataAbertura DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status      ENUM('Aberta','Em_Execucao','Aguardando_Pecas','Concluida','Cancelada') NOT NULL DEFAULT 'Aberta',
  observacoes VARCHAR(255),
  CONSTRAINT fk_os_cli FOREIGN KEY (idCliente) REFERENCES clientes(idCliente)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT fk_os_vei FOREIGN KEY (idVeiculo) REFERENCES veiculo(idVeiculo)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Itens de serviço lançados na OS
CREATE TABLE os_item_servico (
  idOS      INT NOT NULL,
  idServico INT NOT NULL,
  qtde      DECIMAL(10,2) NOT NULL DEFAULT 1 CHECK (qtde > 0),
  precoUnit DECIMAL(10,2) NOT NULL CHECK (precoUnit >= 0),
  desconto  DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (desconto >= 0),
  PRIMARY KEY (idOS, idServico),
  CONSTRAINT fk_ois_os FOREIGN KEY (idOS) REFERENCES ordem_servico(idOS)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_ois_serv FOREIGN KEY (idServico) REFERENCES servico_catalogo(idServico)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Peças utilizadas na OS
CREATE TABLE os_item_peca (
  idOS    INT NOT NULL,
  idPeca  INT NOT NULL,
  qtde    DECIMAL(10,2) NOT NULL CHECK (qtde > 0),
  precoUnit DECIMAL(10,2) NOT NULL CHECK (precoUnit >= 0),
  desconto  DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (desconto >= 0),
  PRIMARY KEY (idOS, idPeca),
  CONSTRAINT fk_oip_os FOREIGN KEY (idOS) REFERENCES ordem_servico(idOS)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_oip_peca FOREIGN KEY (idPeca) REFERENCES peca(idPeca)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Alocação de mecânicos em OS (muitos-para-muitos com horas)
CREATE TABLE os_mecanico (
  idOS       INT NOT NULL,
  idMecanico INT NOT NULL,
  horas      DECIMAL(10,2) NOT NULL CHECK (horas >= 0),
  valorHora  DECIMAL(10,2) NOT NULL CHECK (valorHora >= 0),
  PRIMARY KEY (idOS, idMecanico),
  CONSTRAINT fk_osm_os FOREIGN KEY (idOS) REFERENCES ordem_servico(idOS)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_osm_mec FOREIGN KEY (idMecanico) REFERENCES mecanico(idMecanico)
    ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Pagamentos da OS
CREATE TABLE pagamento (
  idPagamento INT AUTO_INCREMENT PRIMARY KEY,
  idOS        INT NOT NULL UNIQUE,
  forma       ENUM('Dinheiro','Cartao','Pix','Boleto','Transferencia') NOT NULL DEFAULT 'Pix',
  status      ENUM('Pendente','Pago','Estornado','Cancelado') NOT NULL DEFAULT 'Pendente',
  valor       DECIMAL(12,2) NOT NULL CHECK (valor >= 0),
  dataPagto   DATETIME,
  CONSTRAINT fk_pag_os FOREIGN KEY (idOS) REFERENCES ordem_servico(idOS)
    ON UPDATE CASCADE ON DELETE CASCADE
);

-- Agendamentos (pré-OS)
CREATE TABLE agendamento (
  idAgendamento INT AUTO_INCREMENT PRIMARY KEY,
  idCliente INT NOT NULL,
  idVeiculo INT NOT NULL,
  dataHora DATETIME NOT NULL,
  motivo  VARCHAR(120),
  status  ENUM('Agendado','Confirmado','Cancelado','No_Show','Atendido') DEFAULT 'Agendado',
  CONSTRAINT fk_ag_cli FOREIGN KEY (idCliente) REFERENCES clientes(idCliente)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_ag_vei FOREIGN KEY (idVeiculo) REFERENCES veiculo(idVeiculo)
    ON UPDATE CASCADE ON DELETE CASCADE
);