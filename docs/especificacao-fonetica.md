# Especificacao Fonetica

Este documento define o contrato funcional de `fn_br_fonetica_ptbr()` dentro do escopo deste projeto.

## Objetivo

`fn_br_fonetica_ptbr()` gera uma chave fonetica auxiliar pragmatica para portugues brasileiro, adequada para reduzir candidatos em processos de matching.

Ela nao e:

- implementacao oficial perfeita de Metaphone-PTBR;
- decisora final de identidade;
- substituta de revisao contextual, UF, ranking textual ou regras de negocio.

## Escopo de compatibilidade

- MySQL 5.7+
- MySQL 8+
- Percona Server 5.7+
- Percona Server 8+

Restricoes:

- SQL puro;
- sem `REGEXP_REPLACE`;
- sem UDF nativa como requisito;
- sem recursos exclusivos do MySQL 8;
- funcao `DETERMINISTIC` e `NO SQL` quando aplicavel.

## Dependencias permitidas

- `fn_br_fonetica_ptbr()` pode chamar `fn_br_norm_texto()`.

Dependencias proibidas:

- `fn_br_fonetica_ptbr()` nao deve chamar `fn_br_norm_cidade()`.

Motivo:

- a fonetica precisa permanecer generica para cidade, rua, pessoa e razao social;
- heuristicas municipais devem ficar isoladas em `fn_br_norm_cidade()`.

## Papel no pipeline

Pipeline recomendado:

1. Receber texto bruto.
2. Normalizar texto.
3. Para cidades, usar UF confiavel.
4. Fazer match exato por contexto + valor normalizado.
5. Se falhar, usar chave fonetica para reduzir candidatos.
6. Fazer ranking final por similaridade textual ou revisao.

## Contrato semantico do MVP

No MVP, a funcao deve priorizar:

- previsibilidade;
- auditabilidade;
- regras explicitas;
- baixo acoplamento;
- comportamento estavel entre versoes suportadas do MySQL.

No MVP, a funcao ainda nao precisa capturar todos os fenomenos foneticos do pt-BR.

## Fenomenos foneticos prioritarios para evolucao

Os proximos refinamentos devem ser avaliados com corpus e testes de regressao para cobrir, quando fizer sentido:

- `LH`
- `NH`
- `CH`
- `PH -> F`
- `TH -> T`
- `R` forte inicial
- `R` forte final
- `X` contextual
- `SC[EI]`
- `SC[AOU]`
- colapso de consoantes repetidas
- variacoes como `I/Y`, `S/Z`, `QU/K`

## Casos-alvo de convergencia futura

Os pares abaixo sao bons candidatos para convergir na mesma chave fonetica em versoes futuras, desde que os testes confirmem ganho de recall sem explosao de colisao:

- `Joao` / `João`
- `Luiz` / `Luis`
- `Thiago` / `Tiago`
- `Queiroz` / `Keiroz`
- `Xavier` / `Chavier`

Esses pares devem ser tratados como corpus de evolucao, nao como promessa silenciosa do stub inicial.

## Casos que exigem cautela

A funcao nao deve colapsar indiscriminadamente pares que podem representar entidades diferentes. Exemplos para observacao futura:

- `Adriana` / `Adriano`
- `Mara` / `Maria`
- `Bento` / `Vento`
- `Rosa` / `Rocha`

## Regra de governanca

Qualquer nova heuristica fonetica deve vir acompanhada de:

- caso de teste positivo;
- caso de regressao para evitar colisoes excessivas quando aplicavel;
- atualizacao da documentacao quando a semantica mudar.

## Licenca e referencias externas

Papers e implementacoes externas servem como referencia conceitual e comparativa.

Nao copiar codigo de projetos externos sem verificar licenca.

Quando houver duvida:

- usar o paper e implementacoes publicas como fonte de especificacao funcional;
- reimplementar as regras no estilo do projeto;
- registrar as decisoes em testes e documentacao.
