# mysql-phonetic-ptbr

Biblioteca open source de funcoes SQL puras para MySQL e Percona Server 5.7+ com foco em normalizacao textual e geracao de chave fonetica auxiliar para portugues brasileiro.

## Problema

Cadastros brasileiros costumam chegar com variacoes de acento, pontuacao, particulas, abreviacoes e grafias diferentes para o mesmo valor logico. Isso afeta matching de cidades, pessoas e logradouros.

Exemplos comuns:

- `Sao Paulo` x `São Paulo`
- `Santa Barbara d'Oeste` x `Santa Barbara Oeste`
- `Sant'Ana do Livramento` x `Santana do Livramento` x `Sant Ana do Livramento`

## Por que `SOUNDEX()` nao basta

`SOUNDEX()` do MySQL foi pensado para ingles e nao captura bem padroes foneticos do portugues brasileiro. Ele tambem nao resolve sozinho problemas de:

- acentos e cedilha;
- apostrofos e pontuacao;
- particulas como `de`, `do`, `dos`, `d'`;
- normalizacao especifica para nomes brasileiros.

## Por que SQL puro em MySQL/Percona 5.7+

Uma abordagem SQL pura ajuda quando o banco precisa executar a regra sem depender de plugins, UDF nativa, bibliotecas externas ou recursos exclusivos do MySQL 8. Isso facilita auditoria, instalacao e portabilidade entre:

- MySQL 5.7+
- MySQL 8+
- Percona Server 5.7+
- Percona Server 8+

## Escopo do MVP

As quatro funcoes principais previstas sao:

- `fn_br_remove_acentos(p_txt VARCHAR(255))`
- `fn_br_norm_texto(p_txt VARCHAR(255))`
- `fn_br_norm_cidade(p_cidade VARCHAR(255), p_uf CHAR(2))`
- `fn_br_fonetica_ptbr(p_txt VARCHAR(255))`

A funcao fonetica deve ser tratada como chave auxiliar pragmatica para reduzir candidatos. Ela nao deve ser usada como decisao final de matching.

## Regras tecnicas

- Compatibilidade com MySQL/Percona 5.7+.
- Nao usar `REGEXP_REPLACE`.
- Nao usar indices funcionais como requisito.
- Nao usar generated columns como requisito.
- Nao usar plugins externos.
- Nao usar UDF nativa.
- Nao usar bibliotecas externas.
- Nao usar recursos exclusivos do MySQL 8.
- Declarar `DETERMINISTIC` e `NO SQL` quando aplicavel.

## Instalacao

No cliente MySQL:

```sql
SOURCE sql/install_all.sql;
```

## Testes

Execute os arquivos em `tests/` depois da instalacao. Exemplo:

```sql
SOURCE sql/install_all.sql;
SOURCE tests/01_test_remove_acentos.sql;
SOURCE tests/02_test_norm_texto.sql;
SOURCE tests/03_test_norm_cidade.sql;
SOURCE tests/04_test_fonetica_ptbr.sql;
SOURCE tests/05_regressao_santana_livramento.sql;
```

Os testes atuais sao SQL simples, voltados a validacao manual e regressao inicial.

## Pipeline recomendado

1. Receber texto bruto.
2. Normalizar texto.
3. Para cidades, usar UF confiavel.
4. Fazer match exato por UF + cidade_norm.
5. Se falhar, usar chave fonetica como filtro de candidatos.
6. Fazer ranking final por similaridade textual ou revisao.

## Coluna materializada e indice

O projeto recomenda persistir o valor normalizado ou a chave auxiliar em coluna materializada mantida pela aplicacao ou ETL.

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

Isso evita depender de recursos avancados do banco e costuma performar melhor em producao.

## Casos obrigatorios do inicio do projeto

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

## Estado atual

Esta primeira etapa prioriza estrutura, documentacao e implementacoes iniciais simples, auditaveis e testaveis. A regra fonetica ainda e propositalmente conservadora.
