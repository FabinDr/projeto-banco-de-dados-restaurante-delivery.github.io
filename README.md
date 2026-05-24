# Projeto I — Banco de Dados
## Sistema: Restaurante Delivery

**Universidade Federal do Maranhão — UFMA** <br>
**Curso:** Bacharelado Interdisciplinar em Ciência e Tecnologia <br>
**Disciplina:** Banco de Dados <br>
**Professor:** Cláudio Aroucha <br>
**Equipe:** Fabio, Brendo e Lara | 2026.1

---

## 1. Minimundo

O sistema de banco de dados tem como objetivo gerenciar as operações de um **único restaurante** que trabalha exclusivamente no modelo **delivery**. O restaurante possui um cardápio próprio com produtos organizados por categorias, atende clientes por meio de pedidos online e conta com uma equipe de entregadores para realizar as entregas.

### Como funciona, passo a passo:

**Cadastro do cliente:** O cliente se cadastra informando nome, e-mail e CPF. Ele pode registrar múltiplos endereços de entrega e um ou mais telefones de contato.

**Cardápio:** O restaurante organiza seus produtos em categorias (ex.: Lanches, Bebidas, Sobremesas, Pratos). Cada produto pertence a uma única categoria e possui nome, descrição, preço e status de disponibilidade.

**Realizando um pedido:** O cliente escolhe um ou mais produtos e confirma o pedido, selecionando o endereço de entrega. O pedido é registrado com data, hora e status (ex.: *aguardando*, *em preparo*, *saiu para entrega*, *entregue*). Os produtos selecionados formam os itens do pedido, com quantidade, preço unitário no momento da compra e observações (ex.: *sem cebola*). Um funcionário interno (atendente ou cozinheiro) é responsável por atender e preparar o pedido.

**Pagamento:** Cada pedido gera exatamente um registro de pagamento, com o método escolhido (Pix, cartão de crédito, cartão de débito ou dinheiro), valor e status (pendente, confirmado ou estornado).

**Entrega:** Quando o pedido está pronto, ele é atribuído a um entregador. Cada entregador possui um veículo cadastrado (moto, bicicleta ou carro), com tipo, placa, marca e modelo. A entrega é registrada com horário de saída, horário de chegada e status (em rota, entregue, falhou).

**Avaliação:** Após receber o pedido, o cliente pode registrar uma avaliação com nota de 1 a 5 estrelas e um comentário opcional. Isso permite ao restaurante acompanhar a satisfação dos clientes ao longo do tempo.

### Atores do sistema:

| Ator | O que faz |
|---|---|
| Cliente | Cadastra-se, escolhe endereço, faz pedidos, paga e avalia |
| Funcionário | Atende ou prepara o pedido internamente |
| Entregador | Realiza a entrega usando um veículo cadastrado |

---

## 2. Entidades (11 entidades — 12 tabelas no modelo relacional)

| # | Entidade | Tipo | O que representa |
|---|---|---|---|
| 1 | CLIENTE | Forte | Pessoa que realiza pedidos no restaurante |
| 2 | ENDERECO | Forte | Endereços de entrega cadastrados pelo cliente |
| 3 | CATEGORIA | Forte | Categoria dos produtos do cardápio |
| 4 | PRODUTO | Forte | Item disponível no cardápio |
| 5 | FUNCIONARIO | Forte | Funcionário interno do restaurante |
| 6 | PEDIDO | Forte | Pedido realizado por um cliente |
| 7 | ITEM_PEDIDO | **Fraca** | Produto dentro de um pedido (N:N com atributos) |
| 8 | PAGAMENTO | Forte | Registro do pagamento de um pedido |
| 9 | VEICULO | Forte | Veículo utilizado pelo entregador nas entregas |
| 10 | ENTREGADOR | Forte | Responsável por realizar as entregas |
| 11 | ENTREGA | Forte | Registro da operação de entrega |
| 12 | AVALIACAO | Forte | Avaliação do cliente sobre o pedido recebido |

> O atributo multivalorado `telefone` do CLIENTE gera uma 12ª tabela: `CLIENTE_TELEFONE`.<br>
> Total de tabelas no modelo relacional: **12**.

---

## 3. Atributos de cada entidade

#### CLIENTE
| Atributo | Tipo | Observação |
|---|---|---|
| **id_cliente** | Inteiro | Chave Primária |
| nome | Texto | — |
| email | Texto | Único |
| cpf | Texto(11) | Único |
| data_cadastro | Data | — |
| telefone | Texto | Multivalorado → vira tabela CLIENTE_TELEFONE |

#### ENDERECO
| Atributo | Tipo | Observação |
|---|---|---|
| **id_endereco** | Inteiro | Chave Primária |
| id_cliente | Inteiro | FK → CLIENTE |
| rua | Texto | Parte do atributo composto endereco |
| numero | Texto | Parte do atributo composto endereco |
| bairro | Texto | Parte do atributo composto endereco |
| cidade | Texto | Parte do atributo composto endereco |
| cep | Texto(8) | Parte do atributo composto endereco |
| complemento | Texto | Opcional |

> O atributo composto `endereco` foi decomposto em atributos simples para atender a 1FN.

#### CATEGORIA
| Atributo | Tipo | Observação |
|---|---|---|
| **id_categoria** | Inteiro | Chave Primária |
| nome | Texto | ex.: Lanches, Bebidas, Sobremesas |
| descricao | Texto | — |

#### PRODUTO
| Atributo | Tipo | Observação |
|---|---|---|
| **id_produto** | Inteiro | Chave Primária |
| id_categoria | Inteiro | FK → CATEGORIA |
| nome | Texto | — |
| descricao | Texto | — |
| preco | Decimal | — |
| disponivel | Booleano | Ativo/inativo no cardápio |

#### FUNCIONARIO
| Atributo | Tipo | Observação |
|---|---|---|
| **id_funcionario** | Inteiro | Chave Primária |
| nome | Texto | — |
| cargo | Texto | ex.: Atendente, Cozinheiro |
| data_admissao | Data | — |

#### PEDIDO
| Atributo | Tipo | Observação |
|---|---|---|
| **id_pedido** | Inteiro | Chave Primária |
| id_cliente | Inteiro | FK → CLIENTE |
| id_endereco | Inteiro | FK → ENDERECO |
| id_funcionario | Inteiro | FK → FUNCIONARIO |
| data_hora | Data/Hora | Momento do pedido |
| status | Texto | aguardando / em preparo / saiu / entregue |
| total | Decimal | Valor total do pedido |

#### ITEM_PEDIDO — Entidade Fraca
| Atributo | Tipo | Observação |
|---|---|---|
| **id_pedido** | Inteiro | FK → PEDIDO (parte da PK composta) |
| **id_produto** | Inteiro | FK → PRODUTO (parte da PK composta) |
| quantidade | Inteiro | — |
| preco_unitario | Decimal | Preço no momento da compra |
| observacao | Texto | ex.: sem cebola, bem passado |

> Chave Primária composta: `(id_pedido, id_produto)`. Depende de PEDIDO para existir.

#### PAGAMENTO
| Atributo | Tipo | Observação |
|---|---|---|
| **id_pagamento** | Inteiro | Chave Primária |
| id_pedido | Inteiro | FK → PEDIDO |
| metodo | Texto | Pix, Cartão Crédito, Cartão Débito, Dinheiro |
| status | Texto | pendente / confirmado / estornado |
| data_hora | Data/Hora | — |
| valor | Decimal | — |

#### VEICULO
| Atributo | Tipo | Observação |
|---|---|---|
| **id_veiculo** | Inteiro | Chave Primária |
| tipo | Texto | Moto, Bicicleta, Carro |
| placa | Texto | Único |
| marca | Texto | ex.: Honda, Yamaha |
| modelo | Texto | ex.: CG 160, Fan 125 |
| ano | Inteiro | Ano de fabricação |

#### ENTREGADOR
| Atributo | Tipo | Observação |
|---|---|---|
| **id_entregador** | Inteiro | Chave Primária |
| id_veiculo | Inteiro | FK → VEICULO |
| nome | Texto | — |
| cpf | Texto(11) | Único |
| telefone | Texto | — |
| disponivel | Booleano | Livre ou em rota |

#### ENTREGA
| Atributo | Tipo | Observação |
|---|---|---|
| **id_entrega** | Inteiro | Chave Primária |
| id_pedido | Inteiro | FK → PEDIDO |
| id_entregador | Inteiro | FK → ENTREGADOR |
| hora_saida | Data/Hora | — |
| hora_entrega | Data/Hora | — |
| status | Texto | em rota / entregue / falhou |

#### AVALIACAO
| Atributo | Tipo | Observação |
|---|---|---|
| **id_avaliacao** | Inteiro | Chave Primária |
| id_cliente | Inteiro | FK → CLIENTE |
| id_pedido | Inteiro | FK → PEDIDO |
| nota | Inteiro | 1 a 5 estrelas |
| comentario | Texto | Opcional |
| data_hora | Data/Hora | — |

---

## 4. Relacionamentos e Cardinalidades

> Notacao: (minima, maxima) conforme padrao do Peter Chen.<br>
> A cardinalidade e anotada no lado oposto da entidade a que se refere.

| Relacionamento | Entidade A | Card. A | Card. B | Entidade B | Descricao |
|---|---|---|---|---|---|
| possui | CLIENTE | (1,1) | (0,n) | ENDERECO | Um cliente tem zero ou varios enderecos |
| faz | CLIENTE | (1,1) | (0,n) | PEDIDO | Um cliente faz zero ou varios pedidos |
| usado_em | ENDERECO | (0,n) | (1,1) | PEDIDO | Um endereco pode ser usado em varios pedidos |
| atende | FUNCIONARIO | (0,n) | (1,1) | PEDIDO | Um funcionario atende varios pedidos |
| agrupa | CATEGORIA | (0,n) | (1,1) | PRODUTO | Uma categoria agrupa varios produtos |
| contem | PEDIDO | (1,n) | (1,1) | ITEM_PEDIDO | Um pedido contem um ou varios itens (identificador) |
| comp_por | PRODUTO | (0,n) | (1,1) | ITEM_PEDIDO | Um produto compoem varios itens de pedido |
| gera | PEDIDO | (1,1) | (1,1) | PAGAMENTO | Cada pedido gera exatamente um pagamento |
| origina | PEDIDO | (1,1) | (1,1) | ENTREGA | Cada pedido origina exatamente uma entrega |
| usa | ENTREGADOR | (1,1) | (0,n) | VEICULO | Um entregador usa um veiculo; um veiculo pode ser de varios entregadores |
| realiza | ENTREGADOR | (0,n) | (1,1) | ENTREGA | Um entregador realiza varias entregas |
| registra | CLIENTE | (0,n) | (1,1) | AVALIACAO | Um cliente registra zero ou varias avaliacoes |
| avalia | PEDIDO | (0,1) | (1,1) | AVALIACAO | Um pedido pode ter zero ou uma avaliacao |

---

## 5. Mapeamento MER para Modelo Relacional

> Entidade forte vira tabela propria.<br>
> Entidade fraca vira tabela com PK composta.<br>
> Relacionamento 1:1 com FK incorporada no lado participante.<br>
> Relacionamento 1:N com FK no lado N.<br>
> Relacionamento N:N vira tabela propria (ITEM_PEDIDO).<br>
> Atributo multivalorado vira tabela separada (CLIENTE_TELEFONE).<br>

```
CLIENTE(id_cliente, nome, email, cpf, data_cadastro)
PK (id_cliente)

CLIENTE_TELEFONE(id_cliente, telefone)
PK (id_cliente, telefone)
FK (id_cliente) referencia CLIENTE

ENDERECO(id_endereco, id_cliente, rua, numero, bairro, cidade, cep, complemento)
PK (id_endereco)
FK (id_cliente) referencia CLIENTE

CATEGORIA(id_categoria, nome, descricao)
PK (id_categoria)

PRODUTO(id_produto, id_categoria, nome, descricao, preco, disponivel)
PK (id_produto)
FK (id_categoria) referencia CATEGORIA

FUNCIONARIO(id_funcionario, nome, cargo, data_admissao)
PK (id_funcionario)

PEDIDO(id_pedido, id_cliente, id_endereco, id_funcionario, data_hora, status, total)
PK (id_pedido)
FK (id_cliente) referencia CLIENTE
FK (id_endereco) referencia ENDERECO
FK (id_funcionario) referencia FUNCIONARIO

ITEM_PEDIDO(id_pedido, id_produto, quantidade, preco_unitario, observacao)
PK (id_pedido, id_produto)
FK (id_pedido) referencia PEDIDO
FK (id_produto) referencia PRODUTO

PAGAMENTO(id_pagamento, id_pedido, metodo, status, data_hora, valor)
PK (id_pagamento)
FK (id_pedido) referencia PEDIDO

VEICULO(id_veiculo, tipo, placa, marca, modelo, ano)
PK (id_veiculo)

ENTREGADOR(id_entregador, id_veiculo, nome, cpf, telefone, disponivel)
PK (id_entregador)
FK (id_veiculo) referencia VEICULO

ENTREGA(id_entrega, id_pedido, id_entregador, hora_saida, hora_entrega, status)
PK (id_entrega)
FK (id_pedido) referencia PEDIDO
FK (id_entregador) referencia ENTREGADOR

AVALIACAO(id_avaliacao, id_cliente, id_pedido, nota, comentario, data_hora)
PK (id_avaliacao)
FK (id_cliente) referencia CLIENTE
FK (id_pedido) referencia PEDIDO
```

---

## 6. Normalizacao ate a 3a Forma Normal (3FN)

### 6.1 Primeira Forma Normal (1FN)

**Definicao:** Todos os atributos sao atomicos (indivisiveis) e nao existem grupos repetitivos.

**O que foi feito para garantir a 1FN:**

O atributo composto `endereco` foi decomposto em `rua`, `numero`, `bairro`, `cidade`, `cep` e `complemento`. Sem essa decomposicao, o atributo guardaria um texto unico como "Rua das Flores, 10, Centro" que nao e atomico.

O atributo multivalorado `telefone` do CLIENTE foi separado na tabela `CLIENTE_TELEFONE(id_cliente, telefone)`. Sem essa separacao, seria necessario criar colunas repetidas como `telefone1`, `telefone2` — o que viola a 1FN.

Os produtos de um pedido nao estao em colunas repetidas dentro de PEDIDO. Cada produto esta registrado como uma linha em `ITEM_PEDIDO` — sem grupos repetitivos.

Todas as tabelas possuem chave primaria definida.

**Conclusao: todas as tabelas estao em 1FN.**

---

### 6.2 Segunda Forma Normal (2FN)

**Definicao:** Estar em 1FN e todos os atributos nao-chave dependerem totalmente da chave primaria. Aplica-se apenas a tabelas com chave primaria composta.

**Tabela com chave composta: ITEM_PEDIDO(id_pedido, id_produto)**

| Atributo | Depende so de id_pedido? | Depende so de id_produto? | Depende dos dois? |
|---|---|---|---|
| quantidade | Nao | Nao | Sim |
| preco_unitario | Nao | Nao | Sim |
| observacao | Nao | Nao | Sim |

Todos os atributos dependem do par completo `(id_pedido, id_produto)`. Nao ha dependencia parcial.

**Tabela com chave composta: CLIENTE_TELEFONE(id_cliente, telefone)**

Nao possui atributos alem da propria PK. Sem risco de dependencia parcial.

**Conclusao: todas as tabelas estao em 2FN.**

---

### 6.3 Terceira Forma Normal (3FN)

**Definicao:** Estar em 2FN e nao haver dependencias transitivas, ou seja, nenhum atributo nao-chave depende de outro atributo nao-chave.

**Exemplos de dependencias transitivas que foram evitadas:**

*PRODUTO:* Se `nome_categoria` estivesse dentro de PRODUTO, teriamos `id_produto → id_categoria → nome_categoria`, que e transitiva. Solucao: `nome_categoria` esta em CATEGORIA, referenciada por FK.

*PEDIDO:* Se `nome_cliente` estivesse em PEDIDO, teriamos `id_pedido → id_cliente → nome_cliente`. Solucao: dados do cliente estao em CLIENTE.

*ENTREGADOR:* Se `placa` e `tipo` do veiculo estivessem em ENTREGADOR, teriamos `id_entregador → id_veiculo → placa`. Solucao: dados do veiculo estao em VEICULO, entidade propria — exatamente o que o professor pediu.

**Verificacao de todas as tabelas:**

| Tabela | Dependencia transitiva? | Situacao |
|---|---|---|
| CLIENTE | Nenhuma | Em 3FN |
| CLIENTE_TELEFONE | Nenhuma | Em 3FN |
| ENDERECO | Nenhuma | Em 3FN |
| CATEGORIA | Nenhuma | Em 3FN |
| PRODUTO | Nenhuma | Em 3FN |
| FUNCIONARIO | Nenhuma | Em 3FN |
| PEDIDO | Nenhuma | Em 3FN |
| ITEM_PEDIDO | Nenhuma | Em 3FN |
| PAGAMENTO | Nenhuma | Em 3FN |
| VEICULO | Nenhuma | Em 3FN |
| ENTREGADOR | Nenhuma | Em 3FN |
| ENTREGA | Nenhuma | Em 3FN |
| AVALIACAO | Nenhuma | Em 3FN |

**Conclusao: todas as tabelas estao em 3FN.**

---

## 7. Resumo Final do Modelo

### Tabelas geradas (13 no total)

| # | Tabela | Origem no MER | Chave Primaria |
|---|---|---|---|
| 1 | CLIENTE | Entidade forte | id_cliente |
| 2 | CLIENTE_TELEFONE | Atributo multivalorado | (id_cliente, telefone) |
| 3 | ENDERECO | Entidade forte | id_endereco |
| 4 | CATEGORIA | Entidade forte | id_categoria |
| 5 | PRODUTO | Entidade forte | id_produto |
| 6 | FUNCIONARIO | Entidade forte | id_funcionario |
| 7 | PEDIDO | Entidade forte | id_pedido |
| 8 | ITEM_PEDIDO | Entidade fraca / relac. N:N | (id_pedido, id_produto) |
| 9 | PAGAMENTO | Entidade forte | id_pagamento |
| 10 | VEICULO | Entidade forte | id_veiculo |
| 11 | ENTREGADOR | Entidade forte | id_entregador |
| 12 | ENTREGA | Entidade forte | id_entrega |
| 13 | AVALIACAO | Entidade forte | id_avaliacao |

### Justificativa de cada decisao de projeto

| Decisao | Justificativa |
|---|---|
| ITEM_PEDIDO como entidade fraca | Relacao N:N entre PEDIDO e PRODUTO com atributos proprios (qtd, preco, obs) |
| CLIENTE_TELEFONE separada | Atributo multivalorado exige tabela propria (regra de mapeamento + 1FN) |
| VEICULO como entidade separada | Evita dependencia transitiva em ENTREGADOR e permite trocar veiculo sem perder historico |
| AVALIACAO ligada ao PEDIDO | Garante que so e possivel avaliar um pedido que realmente foi realizado |
| preco_unitario em ITEM_PEDIDO | O preco do produto pode mudar; o preco da compra deve ser preservado no historico |

---

*Projeto I — Banco de Dados | UFMA — BICT | 2026.1*

---
## Observacao sobre FUNCIONARIO

FUNCIONARIO utiliza **especializacao parcial e exclusiva** (p, d):

- **Parcial (p):** nem todo funcionario precisa ser classificado como atendente ou cozinheiro (pode haver outros cargos futuramente)<br>
- **Disjunta (d):** um funcionario e atendente OU cozinheiro — nunca os dois<br>

