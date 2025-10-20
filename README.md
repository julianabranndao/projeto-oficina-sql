🧰 Projeto SQL — Oficina Mecânica
🧩 Descrição Geral

Projeto de modelagem e implementação de um banco de dados relacional para uma Oficina Mecânica, cobrindo:

Modelo lógico (EER) coerente com operações reais de oficina

Criação do esquema SQL (DDL)

Inserção de dados (DML)

Consultas SQL com SELECT, WHERE, JOIN, GROUP BY, HAVING e ORDER BY

📂 Estrutura do Repositório
/projeto-oficina-sql
├── sql/
│   ├── esquema_logico.sql
│   ├── inserts_data_oficina.sql
│   └── queries_oficina.sql
├── docs/
│   ├── EER_Oficina.png
│   └── EER_Oficina.pdf
└── README.md

🗄️ Modelo Lógico (EER)

Arquivos disponíveis:

docs/EER_Oficina.png

docs/EER_Oficina.pdf

O modelo contempla:

Clientes (PF/PJ) com especializações

Veículos vinculados a clientes

Ordens de Serviço (OS) como núcleo do processo

Serviços e Peças no catálogo

Mecânicos e sua alocação por OS

Fornecedores e relação de peças por fornecedor

Pagamentos (1:1 com OS)

Agendamentos (pré-OS)

🧱 Criação do Esquema (DDL)

Script de criação do banco de dados (tabelas, chaves, tipos e constraints):
sql/esquema_logico.sql

🌱 Inserção de Dados (DML)

Conjunto de INSERTs com dados genéricos para testes e validação:
sql/inserts_data_oficina.sql

Estrutura Transacional

Transações SQL garantem execução atômica e segura durante as inserções:

START TRANSACTION;

-- Blocos de inserção de dados

COMMIT;


🔒 Se algo falhar no meio, nada é gravado parcialmente, garantindo integridade total dos dados.

🔎 Consultas SQL (Análises)

Consultas criadas para validação e análise do banco de dados:
sql/queries_oficina.sql

Exemplos de Consultas

Quantas OS cada cliente possui (JOIN, GROUP BY)

Mecânicos com mais de 3 serviços executados (HAVING)

Peças em baixo estoque (CASE WHEN)

Pagamentos pendentes e confirmados (WHERE, ORDER BY)

Lucro estimado por serviço (expressões derivadas)

🛠️ Tecnologias & Padrões

MySQL 8 / MySQL Workbench 8

Modelo EER (Crow’s Foot Notation)

SQL padrão (DDL, DML, DQL)

Boas práticas de PK/FK, check constraints, enums e normalização

👩🏻‍💻 Autoria

Projeto desenvolvido por Juliana Brandão

Desafio DIO — Modelagem e Banco de Dados: Oficina Mecânica
