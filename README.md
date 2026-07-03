# mysql-phonetic-ptbr

Biblioteca open source de funções SQL puras para MySQL e Percona Server 5.7+ com foco em normalização textual e geração de chave fonética auxiliar para português brasileiro.

> Status: projeto inicial em fase alpha. A API, as regras de normalização e a semântica da chave fonética ainda podem evoluir nas próximas versões.

## Problema

Cadastros brasileiros costumam chegar com variações de acento, pontuação, partículas, abreviações e grafias diferentes para o mesmo valor lógico. Isso afeta matching de cidades, pessoas e logradouros.

Exemplos comuns:

- `São Paulo` x `Sao Paulo`
- `Santa Bárbara d'Oeste` x `Santa Bárbara Oeste`
- `Sant'Ana do Livramento` x `Santana do Livramento` x `Sant Ana do Livramento`

## Por que `SOUNDEX()` não basta

`SOUNDEX()` do MySQL foi pensado para inglês e não captura bem padrões fonéticos do português brasileiro. Ele também não resolve sozinho problemas de:

- acentos e cedilha;
- apóstrofos e pontuação;
- partículas como `de`, `do`, `dos`, `d'`;
- normalização específica para nomes brasileiros.

## Por que SQL puro em MySQL/Percona 5.7+

Uma abordagem SQL pura ajuda quando o banco precisa executar a regra sem depender de plugins, UDF nativa, bibliotecas externas ou recursos exclusivos do MySQL 8. Isso facilita auditoria, instalação e portabilidade entre:

- MySQL 5.7+
- MySQL 8+
- Percona Server 5.7+
- Percona Server 8+

## Escopo do MVP

As quatro funções principais previstas são:

- `fn_br_remove_acentos(p_txt VARCHAR(255))`
- `fn_br_norm_texto(p_txt VARCHAR(255))`
- `fn_br_norm_cidade(p_cidade VARCHAR(255), p_uf CHAR(2))`
- `fn_br_fonetica_ptbr(p_txt VARCHAR(255))`

A função fonética deve ser tratada como chave auxiliar pragmática para reduzir candidatos. Ela não deve ser usada como decisão final de matching.

## Dependências entre funções

As funções devem ser usáveis de forma independente, mas podem reutilizar funções-base internamente.

Dependências permitidas:

- `fn_br_norm_texto()` pode chamar `fn_br_remove_acentos()`.
- `fn_br_norm_cidade()` pode chamar `fn_br_norm_texto()`.
- `fn_br_fonetica_ptbr()` pode chamar `fn_br_norm_texto()`.

Dependência proibida:

- `fn_br_fonetica_ptbr()` não deve chamar `fn_br_norm_cidade()`.

Motivo:

- `fn_br_norm_cidade()` contém heurísticas específicas de município.
- `fn_br_fonetica_ptbr()` deve continuar genérica para cidade, rua, pessoa e razão social.

## Regras técnicas

- Compatibilidade com MySQL/Percona 5.7+.
- Não usar `REGEXP_REPLACE`.
- Não usar índices funcionais como requisito.
- Não usar generated columns como requisito.
- Não usar plugins externos.
- Não usar UDF nativa.
- Não usar bibliotecas externas.
- Não usar recursos exclusivos do MySQL 8.
- Declarar `DETERMINISTIC` e `NO SQL` quando aplicável.

## Instalação

No cliente MySQL:

```sql
SOURCE sql/install_all.sql;
```

## Testes

Execute os arquivos em `tests/` depois da instalação. Exemplo:

```sql
SOURCE sql/install_all.sql;
SOURCE tests/01_test_remove_acentos.sql;
SOURCE tests/02_test_norm_texto.sql;
SOURCE tests/03_test_norm_cidade.sql;
SOURCE tests/04_test_fonetica_ptbr.sql;
SOURCE tests/05_regressao_santana_livramento.sql;
SOURCE tests/06_test_fonetica_corpus_pesquisa.sql;
```

Os testes atuais são SQL simples, voltados à validação manual e regressão inicial.

Os testes de fonética incluem tanto verificações do comportamento atual quanto casos marcados como `PENDENTE_EVOLUCAO`, que funcionam como corpus versionado para a evolução da regra fonética.

## Pipeline recomendado

1. Receber texto bruto.
2. Normalizar texto.
3. Para cidades, usar UF confiável.
4. Fazer match exato por UF + cidade_norm.
5. Se falhar, usar chave fonética como filtro de candidatos.
6. Fazer ranking final por similaridade textual ou revisão.

## Coluna materializada e índice

O projeto recomenda persistir o valor normalizado ou a chave auxiliar em coluna materializada mantida pela aplicação ou ETL.

Exemplo conceitual:

```sql
ALTER TABLE dim_municipio
  ADD COLUMN cidade_norm VARCHAR(255),
  ADD COLUMN cidade_fonetica VARCHAR(255),
  ADD INDEX ix_dim_municipio_uf_cidade_norm (uf, cidade_norm),
  ADD INDEX ix_dim_municipio_uf_cidade_fonetica (uf, cidade_fonetica);

UPDATE dim_municipio
   SET cidade_norm = fn_br_norm_cidade(nome_municipio, uf),
       cidade_fonetica = fn_br_fonetica_ptbr(fn_br_norm_cidade(nome_municipio, uf));
```

Isso evita depender de recursos avançados do banco e costuma performar melhor em produção.

## Casos obrigatórios do início do projeto

- `São Paulo -> SAO PAULO`
- `Cidade de São Paulo -> SAO PAULO`
- `Cidade Gaúcha -> CIDADE GAUCHA`
- `Santa Bárbara d'Oeste -> SANTA BARBARA OESTE`
- `Alta Floresta D'Oeste -> ALTA FLORESTA OESTE`
- `Pau D'Arco -> PAU ARCO`
- `Mãe d'Água -> MAE AGUA`
- `Olho d'Água das Flores -> OLHO AGUA FLORES`
- `Sant'Ana do Livramento -> SANTANA LIVRAMENTO`
- `Santana do Livramento -> SANTANA LIVRAMENTO`
- `Sant Ana do Livramento -> SANTANA LIVRAMENTO`
- `Abreu e Lima -> ABREU E LIMA`
- `Pontes e Lacerda -> PONTES E LACERDA`
- `Passa e Fica -> PASSA E FICA`
- `Lagoa dos Patos -> LAGOA PATOS`

## Roadmap

### v0.1

- `fn_br_remove_acentos`
- `fn_br_norm_texto`
- `fn_br_norm_cidade`
- `fn_br_fonetica_ptbr`

### v0.2

- `fn_br_collapse_spaces`
- `fn_br_remove_pontuacao`
- `fn_br_only_digits`
- `fn_br_only_letters`
- `fn_br_primeiro_token`
- `fn_br_ultimo_token`

### v0.3

- `fn_br_norm_logradouro`
- `fn_br_norm_bairro`

### v0.4

- `fn_br_norm_nome_pessoa_strict`
- `fn_br_norm_nome_pessoa_loose`

### v0.5

- `fn_br_norm_razao_social`

## Estado atual

Esta primeira etapa prioriza estrutura, documentação e implementações iniciais simples, auditáveis e testáveis. A regra fonética ainda é propositalmente conservadora.

## Ferramentas de desenvolvimento

O projeto pode ser mantido com ferramentas abertas como VSCodium e OpenCode.

Pesquisa, documentação e implementação podem usar apoio de LLMs, mas toda regra do projeto deve ser revisada por humano, testada e documentada antes de entrar no repositório.

## Manutenção

Projeto coordenado por [Emannuel Roque](https://github.com/EmannuelRoque).

- GitHub: [@EmannuelRoque](https://github.com/EmannuelRoque)
- LinkedIn: [emannuelroque](https://www.linkedin.com/in/emannuelroque/)

## Contato e avisos

Se você identificar qualquer ponto relacionado a licença, proveniência de algoritmo, questão jurídica, erro funcional, regressão, colaboração técnica ou sugestão de melhoria, entre em contato ou abra uma issue no repositório.

Especialmente em temas de licença e proveniência, a preferência do projeto é corrigir rápido, documentar a origem das regras e ajustar qualquer trecho necessário com transparência.
