SELECT '06_test_fonetica_corpus_pesquisa' AS test_name;

SELECT 'JOAO' AS grupo,
       'mesma_chave_esperada' AS expectation,
       fn_br_fonetica_ptbr('Joao') AS chave_a,
       fn_br_fonetica_ptbr('João') AS chave_b,
       CASE
         WHEN fn_br_fonetica_ptbr('Joao') = fn_br_fonetica_ptbr('João') THEN 'OK'
         ELSE 'FALHOU'
       END AS status;

SELECT 'LUIZ_LUIS' AS grupo,
       'mesma_chave_alvo_futuro' AS expectation,
       fn_br_fonetica_ptbr('Luiz') AS chave_a,
       fn_br_fonetica_ptbr('Luis') AS chave_b,
       CASE
         WHEN fn_br_fonetica_ptbr('Luiz') = fn_br_fonetica_ptbr('Luis') THEN 'OK'
         ELSE 'PENDENTE_EVOLUCAO'
       END AS status;

SELECT 'THIAGO_TIAGO' AS grupo,
       'mesma_chave_alvo_futuro' AS expectation,
       fn_br_fonetica_ptbr('Thiago') AS chave_a,
       fn_br_fonetica_ptbr('Tiago') AS chave_b,
       CASE
         WHEN fn_br_fonetica_ptbr('Thiago') = fn_br_fonetica_ptbr('Tiago') THEN 'OK'
         ELSE 'PENDENTE_EVOLUCAO'
       END AS status;

SELECT 'QUEIROZ_KEIROZ' AS grupo,
       'mesma_chave_alvo_futuro' AS expectation,
       fn_br_fonetica_ptbr('Queiroz') AS chave_a,
       fn_br_fonetica_ptbr('Keiroz') AS chave_b,
       CASE
         WHEN fn_br_fonetica_ptbr('Queiroz') = fn_br_fonetica_ptbr('Keiroz') THEN 'OK'
         ELSE 'PENDENTE_EVOLUCAO'
       END AS status;

SELECT 'XAVIER_CHAVIER' AS grupo,
       'mesma_chave_alvo_futuro' AS expectation,
       fn_br_fonetica_ptbr('Xavier') AS chave_a,
       fn_br_fonetica_ptbr('Chavier') AS chave_b,
       CASE
         WHEN fn_br_fonetica_ptbr('Xavier') = fn_br_fonetica_ptbr('Chavier') THEN 'OK'
         ELSE 'PENDENTE_EVOLUCAO'
       END AS status;

SELECT 'ADRIANA_ADRIANO' AS grupo,
       'nao_colapsar_indiscriminadamente' AS expectation,
       fn_br_fonetica_ptbr('Adriana') AS chave_a,
       fn_br_fonetica_ptbr('Adriano') AS chave_b,
       CASE
         WHEN fn_br_fonetica_ptbr('Adriana') <> fn_br_fonetica_ptbr('Adriano') THEN 'OK'
         ELSE 'REVISAR_COLISAO'
       END AS status;

SELECT 'MARA_MARIA' AS grupo,
       'nao_colapsar_indiscriminadamente' AS expectation,
       fn_br_fonetica_ptbr('Mara') AS chave_a,
       fn_br_fonetica_ptbr('Maria') AS chave_b,
       CASE
         WHEN fn_br_fonetica_ptbr('Mara') <> fn_br_fonetica_ptbr('Maria') THEN 'OK'
         ELSE 'REVISAR_COLISAO'
       END AS status;

SELECT 'BENTO_VENTO' AS grupo,
       'nao_colapsar_indiscriminadamente' AS expectation,
       fn_br_fonetica_ptbr('Bento') AS chave_a,
       fn_br_fonetica_ptbr('Vento') AS chave_b,
       CASE
         WHEN fn_br_fonetica_ptbr('Bento') <> fn_br_fonetica_ptbr('Vento') THEN 'OK'
         ELSE 'REVISAR_COLISAO'
       END AS status;

SELECT 'ROSA_ROCHA' AS grupo,
       'nao_colapsar_indiscriminadamente' AS expectation,
       fn_br_fonetica_ptbr('Rosa') AS chave_a,
       fn_br_fonetica_ptbr('Rocha') AS chave_b,
       CASE
         WHEN fn_br_fonetica_ptbr('Rosa') <> fn_br_fonetica_ptbr('Rocha') THEN 'OK'
         ELSE 'REVISAR_COLISAO'
       END AS status;
