# 🧰 Projeto de Banco de Dados – Oficina Mecânica (MySQL)

## 📘 Descrição Geral

Este projeto implementa o **modelo lógico de um sistema de Oficina Mecânica**, construído com base em boas práticas de modelagem relacional e normalização.  
O objetivo é representar o funcionamento real de uma oficina, permitindo o gerenciamento de **clientes (PF/PJ)**, **veículos**, **ordens de serviço (OS)**, **serviços**, **peças**, **mecânicos**, **fornecedores**, **pagamentos** e **agendamentos**.

Além da criação do esquema físico no MySQL, o projeto inclui **inserção de dados genéricos de teste** e **consultas SQL complexas** para validação e análise do modelo.

---

## 📊 Modelagem EER

O **diagrama EER** foi desenvolvido no MySQL Workbench, representando a estrutura lógica completa do sistema de oficina.

📷 Inclui:
- Clientes PF/PJ com especialização de atributos  
- Veículos vinculados a seus proprietários  
- Ordens de Serviço (OS) como núcleo do processo operacional  
- Serviços e Peças como entidades independentes e associadas à OS  
- Mecânicos e sua alocação por OS (relação N:N)  
- Fornecedores e relação de peças por fornecedor  
- Pagamentos (relação 1:1 com cada OS)  
- Agendamentos prévios vinculados aos clientes

🧠 O diagrama foi exportado em **PDF** e **PNG** como referência visual do modelo lógico.

📄 Arquivos: [`docs/EER_Oficina.pdf`](docs/EER_Oficina.pdf)  
             [`docs/EER_Oficina.png`](docs/EER_Oficina.png)

---

## 🧩 Criação do Banco e Estrutura Base

Nesta etapa foi definido o **esquema lógico** e implementadas todas as tabelas com suas respectivas **chaves primárias, estrangeiras e constraints**.

📄 Arquivo: [`sql/esquema_logico.sql`](sql/esquema_logico.sql)

### 🧱 Estrutura Geral:
- `clients`, `client_pf`, `client_pj` → Especialização de clientes pessoa física e jurídica  
- `vehicles` → Cadastro de veículos e vínculo com seus respectivos clientes  
- `services`, `parts` → Catálogo de serviços e peças disponíveis  
- `orders` → Ordens de Serviço com status, data e valor total  
- `mechanics` → Registro de mecânicos e suas especialidades  
- `order_mechanic`, `order_service`, `order_part` → Tabelas de relacionamento N:N  
- `suppliers` → Cadastro de fornecedores de peças  
- `supplier_part` → Relação de peças fornecidas por cada fornecedor  
- `payments` → Pagamentos referentes a cada OS  
- `schedules` → Agendamentos prévios de atendimento

### ⚙️ Regras Implementadas:
- **Integridade referencial total** com `ON UPDATE CASCADE` e `ON DELETE RESTRICT`  
- **ENUMs padronizados** para status de OS e formas de pagamento  
- **CHECK constraints** para validar valores numéricos e datas  
- **Relacionamentos N:N** tratados por tabelas intermediárias  
- **Normalização** até 3FN para evitar redundâncias  

---

## 💾 Inserção de Dados

Nesta etapa foi realizada a **população do banco** com dados genéricos de teste, abrangendo todas as tabelas do modelo.

📄 Arquivo: [`sql/inserts_data_oficina.sql`](sql/inserts_data_oficina.sql)

### 🔍 Estrutura e Conteúdo:
- **Clientes (clients)**: 6 registros entre PF e PJ  
- **Veículos (vehicles)**: 8 veículos vinculados a clientes distintos  
- **Serviços e Peças**: catálogo genérico para testes de OS  
- **Mecânicos**: equipe com especializações distintas  
- **Ordens de Serviço (orders)**: ordens abertas, em andamento e concluídas  
- **Pagamentos**: registros de valores pagos e pendentes  
- **Fornecedores e Peças**: vinculação direta via tabela intermediária  
- **Agendamentos**: simulação de pré-cadastros para futuras OS  

---

## ⚙️ Estrutura Transacional

Transações SQL garantem execução **atômica e segura** durante a inserção dos dados:

```sql
START TRANSACTION;

-- Blocos de inserção de dados

COMMIT;
```
🔒 Caso algum erro ocorra durante a execução, nenhum dado é gravado parcialmente, garantindo integridade total do banco.

---

## 📁 Estrutura do Repositório

```text
/projeto-oficina-sql
│
├── docs/
│   ├── EER_Oficina.pdf
│   └── EER_Oficina.png
│
├── sql/
│   ├── esquema_logico.sql
│   ├── inserts_data_oficina.sql
│   └── queries_oficina.sql
│
└── README.md
```

## 🧠 Etapa 4 – Consultas SQL (Análises)

Foram desenvolvidas consultas SQL para **análise e validação do banco de dados**, aplicando **JOINs**, **agrupamentos**, **condições**, **expressões derivadas** e **funções agregadas**.

📄 **Arquivo:** [`sql/queries_oficina.sql`](sql/queries_oficina.sql)

### 🔍 Consultas Implementadas
1. **Quantas OS cada cliente possui** (`JOIN`, `GROUP BY`)  
2. **Mecânicos com mais de 3 serviços executados** (`GROUP BY`, `HAVING`)  
3. **Peças em baixo estoque** (`CASE WHEN`)  
4. **Pagamentos pendentes e confirmados** (`WHERE`, `ORDER BY`)  
5. **Lucro estimado por serviço** (expressões derivadas)  
6. **Serviços mais solicitados por período** (`GROUP BY`, `COUNT`)  
7. **Relação entre fornecedores e peças** (`INNER JOIN`)  

### 🧩 Conceitos Aplicados
- Uso de **INNER e LEFT JOINs** para relacionar tabelas  
- Criação de **atributos derivados** (`ROUND`, `CASE`, `SUM`)  
- Filtros em grupos com **HAVING**  
- Ordenação e filtragem com **ORDER BY**, **WHERE**, **DISTINCT**

### 🧠 Autor
Juliana Brandão
💼 Analista de Dados 📧 contato: (https://www.linkedin.com/in/julianabrandaosv/)
