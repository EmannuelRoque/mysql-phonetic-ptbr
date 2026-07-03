# Especificação Fonética

Este documento define o contrato funcional de `fn_br_fonetica_ptbr()` dentro do escopo deste projeto.

## Objetivo

`fn_br_fonetica_ptbr()` gera uma chave fonética auxiliar pragmática para português brasileiro, adequada para reduzir candidatos em processos de matching.

Ela não é:

- implementação oficial perfeita de Metaphone-PTBR;
- decisora final de identidade;
- substituta de revisão contextual, UF, ranking textual ou regras de negócio.

## Escopo de compatibilidade

- MySQL 5.7+
- MySQL 8+
- Percona Server 5.7+
- Percona Server 8+

Restrições:

- SQL puro;
- sem `REGEXP_REPLACE`;
- sem UDF nativa como requisito;
- sem recursos exclusivos do MySQL 8;
- função `DETERMINISTIC` e `NO SQL` quando aplicável.

## Dependências permitidas

- `fn_br_fonetica_ptbr()` pode chamar `fn_br_norm_texto()`.

Dependências proibidas:

- `fn_br_fonetica_ptbr()` não deve chamar `fn_br_norm_cidade()`.

Motivo:

- a fonética precisa permanecer genérica para cidade, rua, pessoa e razão social;
- heuristicas municipais devem ficar isoladas em `fn_br_norm_cidade()`.

## Papel no pipeline

Pipeline recomendado:

1. Receber texto bruto.
2. Normalizar texto.
3. Para cidades, usar UF confiável.
4. Fazer match exato por contexto + valor normalizado.
5. Se falhar, usar chave fonética para reduzir candidatos.
6. Fazer ranking final por similaridade textual ou revisão.

## Contrato semântico do MVP

No MVP, a função deve priorizar:

- previsibilidade;
- auditabilidade;
- regras explícitas;
- baixo acoplamento;
- comportamento estável entre versões suportadas do MySQL.

No MVP, a função ainda não precisa capturar todos os fenômenos fonéticos do pt-BR.

## Fenômenos fonéticos prioritários para evolução

Os próximos refinamentos devem ser avaliados com corpus e testes de regressão para cobrir, quando fizer sentido:

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
- variações como `I/Y`, `S/Z`, `QU/K`

## Casos-alvo de convergência futura

Os pares abaixo são bons candidatos para convergir na mesma chave fonética em versões futuras, desde que os testes confirmem ganho de recall sem explosão de colisão:

- `Joao` / `João`
- `Luiz` / `Luis`
- `Thiago` / `Tiago`
- `Queiroz` / `Keiroz`
- `Xavier` / `Chavier`

Esses pares devem ser tratados como corpus de evolução, não como promessa silenciosa do stub inicial.

## Casos que exigem cautela

A função não deve colapsar indiscriminadamente pares que podem representar entidades diferentes. Exemplos para observação futura:

- `Adriana` / `Adriano`
- `Mara` / `Maria`
- `Bento` / `Vento`
- `Rosa` / `Rocha`

## Regra de governança

Qualquer nova heurística fonética deve vir acompanhada de:

- caso de teste positivo;
- caso de regressão para evitar colisões excessivas quando aplicável;
- atualização da documentação quando a semântica mudar.

## Licença e referências externas

Papers e implementações externas servem como referência conceitual e comparativa.

Não copiar código de projetos externos sem verificar licença.

Quando houver dúvida:

- usar o paper e implementações públicas como fonte de especificação funcional;
- reimplementar as regras no estilo do projeto;
- registrar as decisões em testes e documentação.
