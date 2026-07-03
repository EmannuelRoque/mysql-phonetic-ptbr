SELECT '04_test_fonetica_ptbr' AS test_name;

SELECT fn_br_norm_cidade('Sant''Ana do Livramento', 'RS') AS cidade_norm,
       fn_br_fonetica_ptbr(fn_br_norm_cidade('Sant''Ana do Livramento', 'RS')) AS chave_fonetica;

SELECT fn_br_norm_cidade('Santa Bárbara d''Oeste', 'SP') AS cidade_norm,
       fn_br_fonetica_ptbr(fn_br_norm_cidade('Santa Bárbara d''Oeste', 'SP')) AS chave_fonetica;
