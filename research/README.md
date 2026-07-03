# Research

Esta pasta reúne materiais de pesquisa, levantamento de referências e análises exploratórias usadas para apoiar a evolução do projeto.

Importante:

- os documentos desta pasta não são normativos por si só;
- eles podem conter hipóteses, alternativas rejeitadas e recomendações que divergem da implementação adotada no repositório;
- decisões efetivas do projeto devem ser refletidas em `README.md`, `OPENCODE.md`, `docs/` e `tests/`.

## Índice

### `pesquisa-alternativas-ao-soundex-ptbr-no-mysql-57.md`

Pesquisa focada em alternativas ao `SOUNDEX()` para português brasileiro com ênfase em MySQL 5.7+.

Pontos fortes:

- ajuda a justificar por que `SOUNDEX()` nativo não basta;
- discute regras fonéticas relevantes para pt-BR;
- traz ideias de higienização por domínio.

Cuidados de leitura:

- propõe caminhos mais ambiciosos que o escopo alpha atual;
- mistura pesquisa, proposta de arquitetura e implementação longa em SQL;
- não deve ser tratada como especificação final do projeto.

### `pesquisa-algoritmos-foneticos-ptbr-ecossistema-licencas-e-arquitetura.md`

Pesquisa mais ampla sobre ecossistema, licenças, referências abertas e estratégias de implementação para algoritmos fonéticos pt-BR.

Pontos fortes:

- bom panorama de ports e repositórios públicos;
- boa análise de risco jurídico e de licença;
- boa base para corpus, métricas e governança de evolução.

Cuidados de leitura:

- recomenda uma arquitetura com core externo antes de SQL puro;
- essa recomendação não substitui o escopo oficial deste repositório;
- deve ser usada como referência analítica, não como norma automática.

## Uso recomendado

Fluxo sugerido para aproveitar esta pasta sem acoplar demais a implementação:

1. Ler as pesquisas como material exploratório.
2. Extrair regras ou hipóteses candidatas.
3. Validar compatibilidade com o escopo do projeto.
4. Converter decisões em documentação normativa e testes de regressão.
