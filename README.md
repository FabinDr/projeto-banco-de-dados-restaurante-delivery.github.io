# Sistema de Delivery de Restaurante — Modelagem de Banco de Dados

Projeto acadêmico da disciplina de Banco de Dados (UFMA — BICT), com a modelagem completa
de um sistema de delivery de restaurante: clientes, endereços, produtos, pedidos, pagamentos,
avaliações, funcionários (atendentes, cozinheiros e entregadores), veículos e entregas.

## 📌 Sobre o projeto

O objetivo é modelar, do zero, o banco de dados de uma plataforma de delivery, cobrindo:

- Modelagem Entidade-Relacionamento (MER)
- Mapeamento para o modelo relacional
- Normalização até a 3ª Forma Normal (3FN)
- Script físico (DDL) pronto para execução em MySQL
- Inserts de exemplo e consultas modelo (DML)

## 🗂️ Modelo Lógico (MER / Diagrama ER)

> 🔗 **Link do diagrama:** https://dbdocs.io/fdribeiro52/Projeto_banco_dados_delivery

O modelo lógico está dividido em 5 áreas temáticas:

1. **Cliente** — Cliente, Endereço, Telefone_Cliente
2. **Catálogo** — Categoria, Produto
3. **Pedido** — Pedido, Item_Pedido, Pagamento, Avaliação
4. **Funcionário** — Funcionario e subtipos (Atendente, Cozinheiro, Entregador)
5. **Entrega** — Veículo, Entregador_Veiculo, Entrega, Prepara_Cozinheiro

## 🧱 Modelo Físico (Script SQL)

> 🔗 **Arquivo do script físico:** [`restaurante_delivery.sql`](./restaurante_delivery_final.sql)

Contém:
- `CREATE TABLE` de todas as entidades
- Chaves primárias (`PRIMARY KEY`) e estrangeiras (`FOREIGN KEY`)
- Relacionamentos de generalização/especialização (`Funcionario` → `Atendente` / `Cozinheiro` / `Entregador`)

## 🖇️ Diagrama Entidade-Relacionamento

```
Cliente 1---N Pedido N---1 Atendente (Funcionario)
Pedido 1---N Item_Pedido N---1 Produto N---1 Categoria
Pedido 1---1 Pagamento
Pedido 1---N Avaliacao
Pedido 1---1 Entrega N---1 Entregador (Funcionario)
Pedido N---N Cozinheiro (via Prepara_Cozinheiro)
Entregador N---N Veiculo (via Entregador_veiculo)
```

## ⚙️ Como executar
Você pode executar os scripts no banco de dados de duas formas: utilizando a interface gráfica de um SGBD ou via linha de comando.

### Opção 1: Manualmente via SGBD (ex: MySQL Workbench)

1. **Abra o SGBD:** Abra o **MySQL Workbench** (ou o SGBD da sua preferência, como DBeaver ou phpMyAdmin) e conecte-se ao seu servidor local.
2. **Crie o Banco de Dados:** Abra uma nova aba de consulta (*Query Tab*) e execute os seguintes comandos para criar e selecionar o banco:
```sql
CREATE DATABASE restaurante_delivery;
USE restaurante_delivery;

```

3. **Abra o Script Físico:** Vá ao menu superior em **File > Open SQL Script...** (Arquivo > Abrir Script SQL) e selecione o ficheiro `restaurante_delivery.sql`.
4. **Execute o Script:** Clique no ícone de **Raio** (*Execute*) para rodar os comandos. Isto criará toda a estrutura de tabelas e relacionamentos automaticamente no SGBD.
5. **Popule os Dados (Opcional):** Para inserir os dados de exemplo e rodar o roteiro de testes, repita o processo: vá a **File > Open SQL Script...**, selecione o ficheiro [`mega_insert.sql`](./mega_insert.sql) e clique novamente no ícone de **Raio** para executar.

### Opção 2: Via Linha de Comando (Terminal)

1. Crie um banco no MySQL:
   ```sql
   CREATE DATABASE restaurante_delivery;
   USE restaurante_delivery;
   ```
2. Execute o script de criação das tabelas:
   ```bash
   mysql -u seu_usuario -p restaurante_delivery < restaurante_delivery.sql
   ```
3. (Opcional) Popule com dados de exemplo e teste as consultas:
   ```bash
   mysql -u seu_usuario -p restaurante_delivery < mega_insert.sql
   ```

## 🛠️ Tecnologias

- **SGBD:** MySQL / MySQL Workbench
- **Modelagem:** draw.io (notação Peter Chen / Crow's Foot)
- **Linguagem:** SQL (DDL + DML)

## 👥 Equipe

- Fabio Duarte Ribeiro
- Brendo Henry Raiol Fernandes
- Lara Sabrina Da Silva Costa

## 🎓 Disciplina

Banco de Dados — Prof. Cláudio Aroucha — UFMA (BICT)
