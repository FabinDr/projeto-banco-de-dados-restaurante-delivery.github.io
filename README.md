# Projeto I — Banco de Dados

## Sistema: Restaurante Delivery

**Universidade Federal do Maranhão — UFMA** <br>
**Curso:** Bacharelado Interdisciplinar em Ciência e Tecnologia <br>
**Disciplina:** Banco de Dados <br>
**Professor:** Msc. Cláudio Aroucha <br>
**Equipe:** Fabio, Brendo e Lara | 2026.1 <br>

---

## 1. Minimundo

O sistema de banco de dados tem como objetivo gerenciar as operações de um **único restaurante** que trabalha exclusivamente no modelo **delivery**. O restaurante possui um cardápio próprio com produtos organizados por categorias, atende clientes por meio de pedidos online e conta com uma equipe de funcionários internos e entregadores para realizar as operações.

### Como funciona, passo a passo

**Cadastro do cliente:** O cliente se cadastra informando nome, e-mail e CPF. Ele pode registrar múltiplos endereços de entrega e um ou mais telefones de contato. O telefone é tratado como atributo multivalorado — representado por elipse dupla no MER — e gera uma tabela separada (`CLIENTE_TELEFONE`) no modelo relacional.

**Cardápio:** O restaurante organiza seus produtos em categorias (ex.: Lanches, Bebidas, Sobremesas, Pratos). Cada produto pertence a exatamente uma categoria e possui nome, descrição, preço e status de disponibilidade (ativo/inativo).

**Realizando um pedido:** O cliente escolhe um ou mais produtos e confirma o pedido, selecionando o endereço de entrega. O pedido é registrado com data, hora, valor total e seu status atual, que é consultado de uma tabela de domínio (`STATUS_PEDIDO`). Os produtos selecionados formam os itens do pedido (`ITEM_PEDIDO`), armazenados com quantidade, preço unitário no momento da compra e observações opcionais (ex.: sem cebola). Um funcionário interno (atendente) é responsável por receber e encaminhar o pedido.

**Funcionários — Especialização (p, d):** O restaurante possui funcionários modelados por meio de uma **especialização parcial e exclusiva (p, d)** no MER de Peter Chen. Por ser parcial, significa que o restaurante pode ter funcionários genéricos que não se encaixam nas subclasses, além dos especializados. No modelo relacional, essa herança foi mapeada criando-se uma tabela genérica e uma tabela para cada especialidade:

* **Funcionário:** Tabela base contendo dados comuns a todos os funcionários (id, nome, data de admissão).
* **Atendente:** Recebe e confirma pedidos. Tabela própria vinculada ao funcionário, contendo o atributo específico `turno` (manhã, tarde ou noite).
* **Cozinheiro:** Prepara os pedidos. Tabela própria vinculada ao funcionário, contendo o atributo específico `especialidade` (ex.: grelhados, massas).
* **Entregador:** Realiza as entregas dos pedidos. Tabela própria vinculada ao funcionário, contendo atributos específicos como `cpf`, `telefone` e status de `disponivel`, além de estar associado ao veículo que utiliza nas entregas.

**Pagamento:** Cada pedido gera exatamente um registro de pagamento. O pagamento armazena o método escolhido, o valor, a data/hora e o status da transação, que é referenciado por meio de uma tabela de domínio (`STATUS_PAGAMENTO`).

**Entrega:** Quando o pedido está pronto, ele é atribuído a um entregador. Cada entregador possui um veículo cadastrado — modelado como entidade forte separada — com tipo (moto, bicicleta ou carro), placa, marca, modelo e ano. A entrega é registrada com horário de saída, horário de chegada e status (em rota, entregue, falhou).

**Avaliação:** Após receber o pedido, o cliente pode registrar uma avaliação com nota de 1 a 5 estrelas e um comentário opcional. A avaliação está vinculada diretamente ao pedido, garantindo que somente clientes que realizaram um pedido possam avaliá-lo.

### Atores do sistema

| Ator | O que faz |
| --- | --- |
| Cliente | Cadastra-se, registra endereços e telefones, faz pedidos, paga e avalia |
| Atendente | Recebe e confirma o pedido internamente |
| Cozinheiro | Prepara o pedido |
| Entregador | Realiza a entrega usando um veículo cadastrado |

---

## 1.1 Modelagem entidade Relacionamento

<img width="2164" height="1130" alt="mer" src="https://github.com/user-attachments/assets/d9e16f1d-72e6-46c1-bf90-60f8a118db95" />

---
## 4. Esquema Relacional Completo

```sql
CLIENTE(id_cliente, nome, email, cpf, data_cad.)
  PK (id_cliente)

CLIENTE_TELEFONE(id_cliente, telefone)
  PK (id_cliente, telefone)
  FK (id_cliente) → CLIENTE

ENDERECO(id_endereco, id_cliente, logradouro, numero, complement., bairro, cep)
  PK (id_endereco)
  FK (id_cliente) → CLIENTE

CATEGORIA(id_categoria, nome, descricao)
  PK (id_categoria)

PRODUTO(id_produto, id_categoria, nome, descricao, preco, disponivel)
  PK (id_produto)
  FK (id_categoria) → CATEGORIA

FUNCIONARIO(id_funcionario, nome, data_adm.)
  PK (id_funcionario)

ATENDENTE(id_funcionario, turno)
  PK (id_funcionario)
  FK (id_funcionario) → FUNCIONARIO

COZINHEIRO(id_funcionario, especialidade)
  PK (id_funcionario)
  FK (id_funcionario) → FUNCIONARIO

STATUS_PEDIDO(id_status_pedido, descricao)
  PK (id_status_pedido)

PEDIDO(id_pedido, id_cliente, id_endereco, id_funcionario, id_status_pedido, data_hora, descricao, total)
  PK (id_pedido)
  FK (id_cliente)      → CLIENTE
  FK (id_endereco)     → ENDERECO
  FK (id_funcionario)  → ATENDENTE
  FK (id_status_pedido)→ STATUS_PEDIDO

ITEM_PEDIDO(id_pedido, id_produto, quantidade, preco_unit., observacao)
  PK (id_pedido, id_produto)
  FK (id_pedido)  → PEDIDO
  FK (id_produto) → PRODUTO

STATUS_PAGAMENTO(id_status_pagamento, descricao)
  PK (id_status_pagamento)

PAGAMENTO(id_pagamento, id_pedido, id_status_pagamento, metodo, data_hora, valor)
  PK (id_pagamento)
  FK (id_pedido)           → PEDIDO
  FK (id_status_pagamento) → STATUS_PAGAMENTO

VEICULO(id_veiculo, tipo, placa, marca, modelo, ano)
  PK (id_veiculo)

ENTREGADOR(id_entregador, id_veiculo, cpf, disponivel)
  PK (id_entregador)
  FK (id_veiculo) → VEICULO

ENTREGA(id_entrega, id_pedido, id_entregador, hora_saida, hora_entrega, status_entrega)
  PK (id_entrega)
  FK (id_pedido)     → PEDIDO
  FK (id_entregador) → ENTREGADOR

AVALIACAO(id_avaliacao, id_cliente, id_pedido, nota, comentario, data_hora)
  PK (id_avaliacao)
  FK (id_cliente) → CLIENTE
  FK (id_pedido)  → PEDIDO

```

---
## 3. Normalização até a 3ª Forma Normal (3FN)

### 3.1 Primeira Forma Normal (1FN)

Para garantir atributos atômicos e a ausência de grupos repetitivos:

* O atributo composto `endereço` foi decomposto em colunas atômicas na tabela `ENDERECO`.
* O atributo multivalorado `telefone` foi alocado em uma tabela dedicada (`CLIENTE_TELEFONE`).
* Todos os registros possuem chave primária.

### 3.2 Segunda Forma Normal (2FN)

Aplica-se às tabelas com PK composta (`ITEM_PEDIDO`). Todos os atributos não-chave (`quantidade`, `preco_unit.`, `observacao`) dependem da combinação total da chave `(id_pedido, id_produto)`. Não há dependência de apenas uma parte da chave.

### 3.3 Terceira Forma Normal (3FN)

Para eliminar dependências transitivas e garantir integridade de domínio:

* **Status Isolados:** A criação de `STATUS_PEDIDO` e `STATUS_PAGAMENTO` remove a vulnerabilidade de inconsistência de texto livre ou falhas em ENUMs rígidos. O status depende exclusivamente da sua chave de domínio.
* **Especialização (Tabelas Separadas):** Os dados específicos de `ATENDENTE` e `COZINHEIRO` foram separados em tabelas próprias. Isso evita a existência de colunas com valores nulos constantes na tabela genérica de `FUNCIONARIO`, respeitando puramente o conceito relacional.
* **Veículo:** Os dados do veículo continuam em uma tabela forte separada, evitando a dependência `id_entregador → id_veiculo → placa`.

> **Conclusão:** O esquema de 17 tabelas atende plenamente aos requisitos da Terceira Forma Normal (3FN).

---

## 4. Entidades

O modelo relacional final é composto por **17 tabelas** para garantir a adequada normalização e mapeamento correto das entidades e atributos do MER.

| # | Tabela | Tipo | O que representa |
| --- | --- | --- | --- |
| 1 | CLIENTE | Forte | Pessoa que realiza pedidos no restaurante |
| 2 | CLIENTE_TELEFONE | Multivalorado | Telefones de contato do cliente |
| 3 | ENDERECO | Forte | Endereços de entrega cadastrados pelo cliente |
| 4 | CATEGORIA | Forte | Categoria dos produtos do cardápio |
| 5 | PRODUTO | Forte | Item disponível no cardápio |
| 6 | FUNCIONARIO | Forte | Entidade genérica de funcionários internos |
| 7 | ATENDENTE | Subclasse | Funcionário especializado no atendimento |
| 8 | COZINHEIRO | Subclasse | Funcionário especializado no preparo |
| 9 | STATUS_PEDIDO | Domínio | Catálogo de estados possíveis para um pedido |
| 10 | PEDIDO | Forte | Pedido realizado por um cliente |
| 11 | ITEM_PEDIDO | Fraca | Produto dentro de um pedido |
| 12 | STATUS_PAGAMENTO | Domínio | Catálogo de estados possíveis para um pagamento |
| 13 | PAGAMENTO | Fraca | Registro de pagamento de um pedido |
| 14 | VEICULO | Forte | Veículo utilizado pelo entregador nas entregas |
| 15 | ENTREGADOR | Forte | Responsável por realizar as entregas |
| 16 | ENTREGA | Forte | Registro da operação de entrega |
| 17 | AVALIACAO | Forte | Avaliação do cliente sobre o pedido recebido |

---

## 5. Atributos por Tabela

### Tabelas de Cliente e Endereço

**CLIENTE**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_cliente** | Inteiro | Chave Primária |
| nome | Texto | — |
| email | Texto | Único |
| cpf | Texto(11) | Único |
| data_cad. | Data | Data de cadastro |

**CLIENTE_TELEFONE**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_cliente** | Inteiro | PK Composta e FK → CLIENTE |
| **telefone** | Texto | PK Composta |

**ENDERECO**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_endereco** | Inteiro | Chave Primária |
| id_cliente | Inteiro | FK → CLIENTE |
| logradouro | Texto | — |
| numero | Texto | — |
| complement. | Texto | — |
| bairro | Texto | — |
| cep | Texto | — |

---

### Tabelas de Produto e Categoria

**CATEGORIA**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_categoria** | Inteiro | Chave Primária |
| nome | Texto | ex.: Lanches, Bebidas |
| descricao | Texto | — |

**PRODUTO**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_produto** | Inteiro | Chave Primária |
| id_categoria | Inteiro | FK → CATEGORIA |
| nome | Texto | — |
| descricao | Texto | — |
| preco | Decimal | — |
| disponivel | Booleano | Ativo/inativo no cardápio |

---

### Tabelas de Funcionários (Especialização)

**FUNCIONARIO**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_funcionario** | Inteiro | Chave Primária |
| nome | Texto | — |
| data_adm. | Data | Data de admissão |

**ATENDENTE**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_funcionario** | Inteiro | PK e FK → FUNCIONARIO |
| turno | Texto | ex.: manha, tarde, noite |

**COZINHEIRO**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_funcionario** | Inteiro | PK e FK → FUNCIONARIO |
| especialidade | Texto | ex.: grelhados, massas |

---

### Tabelas de Pedido e Pagamento

**STATUS_PEDIDO**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_status_pedido** | Inteiro | Chave Primária |
| descricao | Texto | ex.: aguardando, em_preparo, saiu, entregue |

**PEDIDO**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_pedido** | Inteiro | Chave Primária |
| id_cliente | Inteiro | FK → CLIENTE |
| id_endereco | Inteiro | FK → ENDERECO |
| id_funcionario | Inteiro | FK → ATENDENTE (recebeu o pedido) |
| id_status_pedido | Inteiro | FK → STATUS_PEDIDO |
| data_hora | Data/Hora | Momento do pedido |
| descricao | Texto | Observações gerais do pedido |
| total | Decimal | Valor total do pedido |

**ITEM_PEDIDO**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_pedido** | Inteiro | PK Composta e FK → PEDIDO |
| **id_produto** | Inteiro | PK Composta e FK → PRODUTO |
| quantidade | Inteiro | — |
| preco_unit. | Decimal | Preço no momento da compra |
| observacao | Texto | Opcional |

**STATUS_PAGAMENTO**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_status_pagamento** | Inteiro | Chave Primária |
| descricao | Texto | ex.: pendente, confirmado, estornado |

**PAGAMENTO**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_pagamento** | Inteiro | Chave Primária |
| id_pedido | Inteiro | FK → PEDIDO (UNIQUE) |
| id_status_pagamento | Inteiro | FK → STATUS_PAGAMENTO |
| metodo | Texto | ex.: pix, cartao_credito |
| data_hora | Data/Hora | — |
| valor | Decimal | — |

---

### Tabelas de Logística e Feedback

**VEICULO**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_veiculo** | Inteiro | Chave Primária |
| tipo | Texto | ex.: moto, bicicleta |
| placa | Texto | Único |
| marca | Texto | — |
| modelo | Texto | — |
| ano | Inteiro | — |

**ENTREGADOR**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_entregador** | Inteiro | Chave Primária |
| id_veiculo | Inteiro | FK → VEICULO |
| cpf | Texto(11) | Único |
| disponivel | Booleano | Livre ou em rota |

**ENTREGA**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_entrega** | Inteiro | Chave Primária |
| id_pedido | Inteiro | FK → PEDIDO (UNIQUE) |
| id_entregador | Inteiro | FK → ENTREGADOR |
| hora_saida | Data/Hora | — |
| hora_entrega | Data/Hora | Hora de chegada |
| status_entrega | Texto | ex.: em_rota, concluida |

**AVALIACAO**

| Atributo | Tipo | Observação |
| --- | --- | --- |
| **id_avaliacao** | Inteiro | Chave Primária |
| id_cliente | Inteiro | FK → CLIENTE |
| id_pedido | Inteiro | FK → PEDIDO (UNIQUE) |
| nota | Inteiro | 1 a 5 |
| comentario | Texto | Opcional |
| data_hora | Data/Hora | — |
