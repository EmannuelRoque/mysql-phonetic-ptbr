SELECT '03_test_norm_cidade' AS test_name;

SELECT 'SAO PAULO' AS expected,
       fn_br_norm_cidade('São Paulo', 'SP') AS actual;

SELECT 'SAO PAULO' AS expected,
       fn_br_norm_cidade('Cidade de São Paulo', 'SP') AS actual;

SELECT 'CIDADE GAUCHA' AS expected,
       fn_br_norm_cidade('Cidade Gaúcha', 'RS') AS actual;

SELECT 'SANTA BARBARA OESTE' AS expected,
       fn_br_norm_cidade('Santa Bárbara d''Oeste', 'SP') AS actual;

SELECT 'ALTA FLORESTA OESTE' AS expected,
       fn_br_norm_cidade('Alta Floresta D''Oeste', 'RO') AS actual;

SELECT 'PAU ARCO' AS expected,
       fn_br_norm_cidade('Pau D''Arco', 'TO') AS actual;

SELECT 'MAE AGUA' AS expected,
       fn_br_norm_cidade('Mãe d''Água', 'PB') AS actual;

SELECT 'OLHO AGUA FLORES' AS expected,
       fn_br_norm_cidade('Olho d''Água das Flores', 'AL') AS actual;

SELECT 'SANTANA LIVRAMENTO' AS expected,
       fn_br_norm_cidade('Sant''Ana do Livramento', 'RS') AS actual;

SELECT 'SANTANA LIVRAMENTO' AS expected,
       fn_br_norm_cidade('Santana do Livramento', 'RS') AS actual;

SELECT 'SANTANA LIVRAMENTO' AS expected,
       fn_br_norm_cidade('Sant Ana do Livramento', 'RS') AS actual;

SELECT 'ABREU E LIMA' AS expected,
       fn_br_norm_cidade('Abreu e Lima', 'PE') AS actual;

SELECT 'PONTES E LACERDA' AS expected,
       fn_br_norm_cidade('Pontes e Lacerda', 'MT') AS actual;

SELECT 'PASSA E FICA' AS expected,
       fn_br_norm_cidade('Passa e Fica', 'RN') AS actual;

SELECT 'LAGOA PATOS' AS expected,
       fn_br_norm_cidade('Lagoa dos Patos', 'RS') AS actual;
