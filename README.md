# Projeto I — Banco de Dados
## Sistema: Restaurante Delivery

**Universidade Federal do Maranhão — UFMA** <br>
**Curso:** Bacharelado Interdisciplinar em Ciência e Tecnologia<br>
**Disciplina:** Banco de Dados<br>
**Professor:** Msc. Cláudio Aroucha<br>
**Equipe:** Fabio, Brendo e Lara | 2026.1<br>

---

## 1. Minimundo

O sistema de banco de dados tem como objetivo gerenciar as operações de um **único restaurante** que trabalha exclusivamente no modelo **delivery**. O restaurante possui um cardápio próprio com produtos organizados por categorias, atende clientes por meio de pedidos online e conta com uma equipe de funcionários internos e entregadores para realizar as operações.

### Como funciona, passo a passo:

**Cadastro do cliente:** O cliente se cadastra informando nome, e-mail e CPF. Ele pode registrar múltiplos endereços de entrega e um ou mais telefones de contato. O telefone é tratado como atributo multivalorado, gerando uma tabela separada no modelo relacional.

**Cardápio:** O restaurante organiza seus produtos em categorias (ex.: Lanches, Bebidas, Sobremesas, Pratos). Cada produto pertence a uma única categoria e possui nome, descrição, preço e status de disponibilidade.

**Realizando um pedido:** O cliente escolhe um ou mais produtos e confirma o pedido, selecionando o endereço de entrega. O pedido é registrado com data, hora e status (aguardando, em preparo, saiu para entrega, entregue). Os produtos selecionados formam os itens do pedido — registrados com quantidade, preço unitário no momento da compra e observações (ex.: sem cebola). Um funcionário interno é responsável por atender e encaminhar o pedido.

**Funcionários:** O restaurante possui dois tipos de funcionários internos, modelados por meio de uma especialização parcial e exclusiva (p, d):
- **Atendente:** recebe e confirma pedidos. Possui atributo próprio: turno (manhã, tarde ou noite).
- **Cozinheiro:** prepara os pedidos. Possui atributo próprio: especialidade (ex.: grelhados, massas).
No modelo relacional, ambos são armazenados em uma única tabela FUNCIONARIO, com as colunas turno e especialidade preenchidas conforme o cargo — e nulas quando não se aplicam.

**Pagamento:** Cada pedido gera exatamente um registro de pagamento, com o método escolhido (Pix, cartão de crédito, cartão de débito ou dinheiro), valor e status (pendente, confirmado ou estornado).

**Entrega:** Quando o pedido está pronto, ele é atribuído a um entregador. Cada entregador possui um veículo cadastrado — modelado como entidade separada — com tipo (moto, bicicleta ou carro), placa, marca, modelo e ano. A entrega é registrada com horário de saída, horário de chegada e status (em rota, entregue, falhou).

**Avaliação:** Após receber o pedido, o cliente pode registrar uma avaliação com nota de 1 a 5 estrelas e um comentário opcional. A avaliação está vinculada ao pedido, garantindo que somente clientes que realizaram um pedido possam avaliá-lo.

### Atores do sistema:

| Ator | O que faz |
|---|---|
| Cliente | Cadastra-se, escolhe endereço, faz pedidos, paga e avalia |
| Atendente | Recebe e confirma o pedido internamente (turno) |
| Cozinheiro | Prepara o pedido (especialidade) |
| Entregador | Realiza a entrega usando um veículo cadastrado |

---

## 2. Entidades (12 entidades — 13 tabelas no modelo relacional)

| # | Entidade | Tipo | O que representa |
|---|---|---|---|
| 1 | CLIENTE | Forte | Pessoa que realiza pedidos no restaurante |
| 2 | ENDERECO | Forte | Endereços de entrega cadastrados pelo cliente |
| 3 | CATEGORIA | Forte | Categoria dos produtos do cardápio |
| 4 | PRODUTO | Forte | Item disponível no cardápio |
| 5 | FUNCIONARIO | Forte | Funcionário interno com especialização (atendente/cozinheiro) |
| 6 | PEDIDO | Forte | Pedido realizado por um cliente |
| 7 | ITEM_PEDIDO | **Fraca** | Produto dentro de um pedido (relacionamento N:N com atributos) |
| 8 | PAGAMENTO | Forte | Registro do pagamento de um pedido |
| 9 | VEICULO | Forte | Veículo utilizado pelo entregador nas entregas |
| 10 | ENTREGADOR | Forte | Responsável por realizar as entregas |
| 11 | ENTREGA | Forte | Registro da operação de entrega |
| 12 | AVALIACAO | Forte | Avaliação do cliente sobre o pedido recebido |

> O atributo multivalorado `telefone` do CLIENTE gera uma 13ª tabela: `CLIENTE_TELEFONE`.
> Total de tabelas no modelo relacional: **13**.

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
| telefone | Texto | **Multivalorado** → vira tabela CLIENTE_TELEFONE |

> `telefone` é um atributo multivalorado: um cliente pode ter vários números. No MER é representado por elipse dupla. No modelo relacional vira tabela separada.

#### ENDERECO
| Atributo | Tipo | Observação |
|---|---|---|
| **id_endereco** | Inteiro | Chave Primária |
| id_cliente | Inteiro | FK → CLIENTE |
| rua | Texto | Parte do atributo composto `endereco` |
| numero | Texto | Parte do atributo composto `endereco` |
| bairro | Texto | Parte do atributo composto `endereco` |
| cidade | Texto | Parte do atributo composto `endereco` |
| cep | Texto(8) | Parte do atributo composto `endereco` |
| complemento | Texto | Opcional |

> O atributo composto `endereco` foi decomposto em atributos simples para garantir a 1FN.

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

#### FUNCIONARIO *(com especialização parcial e exclusiva)*
| Atributo | Tipo | Observação |
|---|---|---|
| **id_funcionario** | Inteiro | Chave Primária |
| nome | Texto | — |
| cargo | ENUM | `atendente` ou `cozinheiro` |
| data_admissao | Data | — |
| turno | ENUM | `manha`, `tarde`, `noite` — exclusivo do **ATENDENTE** |
| especialidade | Texto | ex.: grelhados, massas — exclusivo do **COZINHEIRO** |

> **Especialização (p, d):** no MER de Peter Chen é representada por um triângulo abaixo de FUNCIONARIO com o rótulo `p` (parcial) e `d` (disjunta/exclusiva), com linhas para as subclasses ATENDENTE e COZINHEIRO.
> **Mapeamento escolhido:** tabela única com colunas extras. Atendente tem `turno` preenchido e `especialidade` = NULL. Cozinheiro tem `especialidade` preenchida e `turno` = NULL.

#### PEDIDO
| Atributo | Tipo | Observação |
|---|---|---|
| **id_pedido** | Inteiro | Chave Primária |
| id_cliente | Inteiro | FK → CLIENTE |
| id_endereco | Inteiro | FK → ENDERECO |
| id_funcionario | Inteiro | FK → FUNCIONARIO |
| data_hora | Data/Hora | Momento do pedido |
| status | ENUM | `aguardando`, `em_preparo`, `saiu`, `entregue`, `cancelado` |
| total | Decimal | Valor total do pedido |

#### ITEM_PEDIDO — Entidade Fraca
| Atributo | Tipo | Observação |
|---|---|---|
| **id_pedido** | Inteiro | FK → PEDIDO (parte da PK composta) |
| **id_produto** | Inteiro | FK → PRODUTO (parte da PK composta) |
| quantidade | Inteiro | — |
| preco_unitario | Decimal | Preço no momento da compra (preservado no histórico) |
| observacao | Texto | ex.: sem cebola, bem passado |

> Chave Primária composta: `(id_pedido, id_produto)`. Depende de PEDIDO para existir — por isso é entidade fraca, representada por retângulo duplo no MER. O relacionamento `contem` é identificador, representado por losango duplo.

#### PAGAMENTO
| Atributo | Tipo | Observação |
|---|---|---|
| **id_pagamento** | Inteiro | Chave Primária |
| id_pedido | Inteiro | FK → PEDIDO |
| metodo | ENUM | `pix`, `cartao_credito`, `cartao_debito`, `dinheiro` |
| status | ENUM | `pendente`, `confirmado`, `estornado` |
| data_hora | Data/Hora | — |
| valor | Decimal | — |

#### VEICULO
| Atributo | Tipo | Observação |
|---|---|---|
| **id_veiculo** | Inteiro | Chave Primária |
| tipo | ENUM | `moto`, `bicicleta`, `carro` |
| placa | Texto | Único |
| marca | Texto | ex.: Honda, Yamaha |
| modelo | Texto | ex.: CG 160, Fan 125 |
| ano | Inteiro | Ano de fabricação |

> VEICULO foi separado de ENTREGADOR a pedido do professor e para evitar dependência transitiva: `id_entregador → id_veiculo → placa` violaria a 3FN.

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
| status | ENUM | `em_rota`, `entregue`, `falhou` |

#### AVALIACAO
| Atributo | Tipo | Observação |
|---|---|---|
| **id_avaliacao** | Inteiro | Chave Primária |
| id_cliente | Inteiro | FK → CLIENTE |
| id_pedido | Inteiro | FK → PEDIDO |
| nota | Inteiro | 1 a 5 estrelas |
| comentario | Texto | Opcional |
| data_hora | Data/Hora | — |

> AVALIACAO está vinculada ao PEDIDO (não apenas ao cliente), garantindo que só é possível avaliar um pedido que realmente foi realizado.

---

## 4. Relacionamentos e Cardinalidades

> Notação: **(mínima, máxima)** conforme padrão Peter Chen / professor Cláudio Aroucha.
> A cardinalidade é anotada no lado **oposto** da entidade a que se refere.

| Relacionamento | Entidade A | Card. A | Card. B | Entidade B | Descrição |
|---|---|---|---|---|---|
| possui | CLIENTE | (1,1) | (0,n) | ENDERECO | Um cliente tem zero ou vários endereços |
| faz | CLIENTE | (1,1) | (0,n) | PEDIDO | Um cliente faz zero ou vários pedidos |
| usado_em | ENDERECO | (0,n) | (1,1) | PEDIDO | Um endereço pode ser usado em vários pedidos |
| atende | FUNCIONARIO | (0,n) | (1,1) | PEDIDO | Um funcionário atende vários pedidos |
| agrupa | CATEGORIA | (0,n) | (1,1) | PRODUTO | Uma categoria agrupa vários produtos |
| **contem** | PEDIDO | (1,n) | (1,1) | ITEM_PEDIDO | Um pedido contém um ou vários itens **(identificador — losango duplo)** |
| comp_por | PRODUTO | (0,n) | (1,1) | ITEM_PEDIDO | Um produto compõe vários itens de pedido |
| gera | PEDIDO | (1,1) | (1,1) | PAGAMENTO | Cada pedido gera exatamente um pagamento |
| origina | PEDIDO | (1,1) | (1,1) | ENTREGA | Cada pedido origina exatamente uma entrega |
| usa | ENTREGADOR | (1,1) | (0,n) | VEICULO | Um entregador usa um veículo; um veículo pode ser de vários entregadores |
| realiza | ENTREGADOR | (0,n) | (1,1) | ENTREGA | Um entregador realiza várias entregas |
| registra | CLIENTE | (0,n) | (1,1) | AVALIACAO | Um cliente registra zero ou várias avaliações |
| avalia | PEDIDO | (0,1) | (1,1) | AVALIACAO | Um pedido pode ter zero ou uma avaliação |

---

## 5. Mapeamento MER para Modelo Relacional
> - Entidade forte → tabela própria
> - Entidade fraca → tabela com PK composta
> - Relacionamento 1:1 → FK incorporada no lado participante
> - Relacionamento 1:N → FK no lado N
> - Relacionamento N:N → tabela própria (ITEM_PEDIDO)
> - Atributo multivalorado → tabela separada (CLIENTE_TELEFONE)
> - Especialização (p,d) → tabela única com colunas extras nulas

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

FUNCIONARIO(id_funcionario, nome, cargo, data_admissao, turno, especialidade)
PK (id_funcionario)
-- turno: preenchido para atendente, NULL para cozinheiro
-- especialidade: preenchida para cozinheiro, NULL para atendente

PEDIDO(id_pedido, id_cliente, id_endereco, id_funcionario, data_hora, status, total)
PK (id_pedido)
FK (id_cliente)     referencia CLIENTE
FK (id_endereco)    referencia ENDERECO
FK (id_funcionario) referencia FUNCIONARIO

ITEM_PEDIDO(id_pedido, id_produto, quantidade, preco_unitario, observacao)
PK (id_pedido, id_produto)
FK (id_pedido)  referencia PEDIDO
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
FK (id_pedido)     referencia PEDIDO
FK (id_entregador) referencia ENTREGADOR

AVALIACAO(id_avaliacao, id_cliente, id_pedido, nota, comentario, data_hora)
PK (id_avaliacao)
FK (id_cliente) referencia CLIENTE
FK (id_pedido)  referencia PEDIDO
```

---

## 6. Normalização até a 3ª Forma Normal (3FN)

### 6.1 Primeira Forma Normal (1FN)

**Definição:** Todos os atributos são atômicos (indivisíveis) e não existem grupos repetitivos.

**O que foi feito para garantir a 1FN:**

O atributo composto `endereco` foi decomposto em `rua`, `numero`, `bairro`, `cidade`, `cep` e `complemento`. Sem essa decomposição, o atributo guardaria um texto único como "Rua das Flores, 10, Centro" — não atômico.

O atributo multivalorado `telefone` do CLIENTE foi separado na tabela `CLIENTE_TELEFONE(id_cliente, telefone)`. Sem essa separação, seria necessário criar colunas repetidas como `telefone1`, `telefone2` — o que viola a 1FN.

Os produtos de um pedido não estão em colunas repetidas dentro de PEDIDO. Cada produto está registrado como uma linha em `ITEM_PEDIDO` — sem grupos repetitivos.

Todas as tabelas possuem chave primária definida.

**Conclusão: todas as tabelas estão em 1FN.**

---

### 6.2 Segunda Forma Normal (2FN)

**Definição:** Estar em 1FN e todos os atributos não-chave dependerem totalmente da chave primária. Aplica-se apenas a tabelas com chave primária composta.

**Tabela com chave composta: ITEM_PEDIDO(id_pedido, id_produto)**

| Atributo | Depende só de id_pedido? | Depende só de id_produto? | Depende dos dois? |
|---|---|---|---|
| quantidade | Não | Não | Sim |
| preco_unitario | Não | Não | Sim |
| observacao | Não | Não | Sim |

Todos os atributos dependem do par completo `(id_pedido, id_produto)`. Não há dependência parcial.

**Tabela com chave composta: CLIENTE_TELEFONE(id_cliente, telefone)**

Não possui atributos além da própria PK. Sem risco de dependência parcial.

**Conclusão: todas as tabelas estão em 2FN.**

---

### 6.3 Terceira Forma Normal (3FN)

**Definição:** Estar em 2FN e não haver dependências transitivas — nenhum atributo não-chave depende de outro atributo não-chave.

**Exemplos de dependências transitivas que foram evitadas:**

*PRODUTO:* Se `nome_categoria` estivesse dentro de PRODUTO, teríamos `id_produto → id_categoria → nome_categoria`. Solução: `nome_categoria` está em CATEGORIA, referenciada por FK.

*PEDIDO:* Se `nome_cliente` estivesse em PEDIDO, teríamos `id_pedido → id_cliente → nome_cliente`. Solução: dados do cliente estão em CLIENTE.

*ENTREGADOR:* Se `placa` e `tipo` do veículo estivessem em ENTREGADOR, teríamos `id_entregador → id_veiculo → placa`. Solução: dados do veículo estão em VEICULO, entidade própria — exatamente o que o professor pediu.

**Verificação de todas as tabelas:**

| Tabela | Dependência transitiva? | Situação |
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

**Conclusão: todas as tabelas estão em 3FN.**

---

## 7. Resumo Final do Modelo

### Tabelas geradas (13 no total)

| # | Tabela | Origem no MER | Chave Primária |
|---|---|---|---|
| 1 | CLIENTE | Entidade forte | id_cliente |
| 2 | CLIENTE_TELEFONE | Atributo multivalorado | (id_cliente, telefone) |
| 3 | ENDERECO | Entidade forte | id_endereco |
| 4 | CATEGORIA | Entidade forte | id_categoria |
| 5 | PRODUTO | Entidade forte | id_produto |
| 6 | FUNCIONARIO | Entidade forte + especialização (p,d) | id_funcionario |
| 7 | PEDIDO | Entidade forte | id_pedido |
| 8 | ITEM_PEDIDO | Entidade fraca / relac. N:N | (id_pedido, id_produto) |
| 9 | PAGAMENTO | Entidade forte | id_pagamento |
| 10 | VEICULO | Entidade forte | id_veiculo |
| 11 | ENTREGADOR | Entidade forte | id_entregador |
| 12 | ENTREGA | Entidade forte | id_entrega |
| 13 | AVALIACAO | Entidade forte | id_avaliacao |

### Justificativa de cada decisão de projeto

| Decisão | Justificativa |
|---|---|
| ITEM_PEDIDO como entidade fraca | Relação N:N entre PEDIDO e PRODUTO com atributos próprios (qtd, preco, obs) |
| CLIENTE_TELEFONE separada | Atributo multivalorado exige tabela própria — regra de mapeamento + 1FN |
| VEICULO como entidade separada | Evita dependência transitiva em ENTREGADOR; pedido explícito do professor |
| AVALIACAO ligada ao PEDIDO | Garante que só é possível avaliar um pedido realmente realizado |
| preco_unitario em ITEM_PEDIDO | O preço do produto pode mudar; o preço da compra deve ser preservado |
| FUNCIONARIO tabela única | Especialização (p,d) mapeada por tabela única com colunas extras nulas — mais simples para consultas |

### Especialização de FUNCIONARIO — resumo visual

```
              FUNCIONARIO
            (id_func, nome, cargo, data_admissao, turno, especialidade)
                     |
               [p, d] triangulo
              /               \
        ATENDENTE          COZINHEIRO
     (turno preenchido)  (especialidade preenchida)
     (especialidade=NULL)   (turno=NULL)
```

---

*Projeto I — Banco de Dados | UFMA — BICT | 2026.1*
