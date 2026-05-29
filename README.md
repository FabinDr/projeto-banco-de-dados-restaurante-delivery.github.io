
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


## 2 Modelagem Entidade Relacionamento - MER
### Visão geral: 
  <img width="2164" height="1131" alt="Diagrama sem nome" src="https://github.com/user-attachments/assets/8d2a44cb-e7c8-41c6-bdf4-0e1584fb01a4" />

### Produtos -> Pedido
<img width="742" height="948" alt="Diagrama sem nome (3)" src="https://github.com/user-attachments/assets/1475c6a3-add7-4339-b9c9-09b21365dba5" />

### Funcionários -> pedidos 
<img width="1250" height="950" alt="func (1)" src="https://github.com/user-attachments/assets/28cf65b0-fbb5-40f1-a72f-13bc1363017b" />

### Cliente, Avaliação, pagamento, Pedido
<img width="1147" height="806" alt="Diagrama sem nome (4)" src="https://github.com/user-attachments/assets/56e7056f-5dd8-4e61-ac6f-81d0dbc4de16" />

---
## 2. Modelo Relacional

Transformando do modelo entidade relacionamento para o modelo relacional.

```sql
Cliente(id_cliente, nome, email, CPF, data_cad, logradouro, numero, bairro, CEP, complemento)
PK (id_cliente)

Telefone_Cliente(id_cliente, telefone)
PK (id_cliente, telefone)
FK (id_cliente) referencia Cliente

Categoria (id_categ, nome, descricao)
PK (id_categ)

Produto (id_prod, nome, descricao, preco, disponivel, id_categ)
PK (id_prod)
FK (id_categ) referencia Categoria

cliente_pedido(id_cliente, id_pedido)
PK (id_cliente, id_pedido)
FK (id_cliente) referencia Cliente
FK (id_pedido) referencia Pedido

Pedido (id_pedido, status_pedido, data_hora, descricao, id_cliente)
PK (id_pedido)
FK (id_cliente) referencia Cliente

Item_Pedido (id_item_ped, quantidade, preco_unit, observacao, id_pedido, id_prod)
PK (id_item_ped)
FK (id_pedido) referencia Pedido
FK (id_prod) referencia Produto

Pagamento(id_pagamento, metodo, status_pagamento, valor, data_hora, id_pedido)
PK (id_pagamento)
FK (id_pedido) referencia Pedido

Avaliacao(id_aval, nota, comentario, data_hora, id_cliente, id_pedido)
PK (id_aval)
FK (id_cliente) referencia Cliente
FK (id_pedido) referencia Pedido

Funcionario(id_func, nome, cargo, data_adm, cpf)
PK (id_func)

Telefone_Funcionario (id_func, telefone)
PK (id_func, telefone)
FK (id_func) referencia Funcionario

Atendente (id_func, turno)
PK (id_func)
FK (id_func) referencia Funcionario

Cozinheiro (id_func, especialidade)
PK (id_func)
FK (id_func) referencia Funcionario

Entregador(id_func, disponivel)
PK (id_func)
FK (id_func) referencia Funcionario

Veiculo(id_veiculo, tipo, placa, marca, modelo, ano, id_func_entregador)
PK (id_veiculo)
FK (id_func_entregador) referencia Entregador

Entrega(id_entrega, hora_saida, hora_entrega, status_entrega, id_pedido, id_func_entregador)
PK (id_entrega)
FK (id_pedido) referencia Pedido
FK (id_func_entregador) referencia Entregador

Atende_Atendente(id_func_atendente, id_pedido)
PK (id_func_atendente, id_pedido)
FK (id_func_atendente) referencia Atendente
FK (id_pedido) referencia Pedido

Prepara_Cozinheiro(id_func_cozinheiro, id_pedido)
PK (id_func_cozinheiro, id_pedido)
FK (id_func_cozinheiro) referencia Cozinheiro
FK (id_pedido) referencia Pedido
```
---
## 3. Normalização. O que foi normalizado?

O modelo relacional gerado a partir do diagrama está normalizado até a **3ª Forma Normal (3FN)**

### 1. Primeira Forma Normal (1FN)
**Regra:** Todos os atributos devem ser atômicos (indivisíveis) e não podem existir atributos multivalorados ou grupos repetitivos.
 * **Como aplicamos:**
   * O atributo composto endereço foi "achatado", ou seja, dividido em seus componentes mais simples (logradouro, numero, bairro, CEP, complemento) diretamente na tabela **Cliente**.
   * Os atributos multivalorados telefone (linha dupla no seu diagrama) foram removidos das tabelas principais e transformados em tabelas próprias (**Telefone_Cliente** e **Telefone_Funcionario**).
### 2. Segunda Forma Normal (2FN)
**Regra:** A tabela deve estar na 1FN e todos os atributos não-chave devem depender totalmente da chave primária (não pode haver dependência parcial em tabelas com chaves compostas).
 * **Como aplicamos:**
   * A grande maioria das suas tabelas possui uma chave primária simples (composta por apenas um atributo, como id_cliente ou id_pedido). Quando a chave é simples, a tabela já está automaticamente na 2FN, pois é impossível que um atributo dependa apenas de "uma parte" da chave.
   * As tabelas que possuem chave primária composta (como **Telefone_Cliente**, **Telefone_Funcionario**, **Atende** e **Prepara**) são tabelas puramente associativas ou de armazenamento de valores múltiplos. Elas não possuem atributos não-chave soltos que dependam apenas de metade da chave. Logo, respeitam a 2FN.
### 3. Terceira Forma Normal (3FN)
**Regra:** A tabela deve estar na 2FN e não pode haver dependência transitiva. Isso significa que um atributo não-chave não pode depender de outro atributo não-chave; todos devem depender única e exclusivamente da chave primária.
 * **Como aplicamos:**
   * Em tabelas como **Pedido**, o status_pedido e a data_hora dependem unicamente do id_pedido. O id_cliente é uma chave estrangeira, o que é perfeitamente válido.
   * Em **Produto**, o nome, descricao e preco dependem do id_prod.
   * Em **Item_Pedido**, o preco_unit (preço histórico cobrado naquele pedido) e a quantidade dependem do id_item_ped. Não há atributos calculados ou derivados sendo armazenados de forma redundante.
