SELECT '01_test_remove_acentos' AS test_name;

SELECT 'SAO PAULO' AS expected, fn_br_remove_acentos('São Paulo') AS actual;
SELECT 'CIDADE GAUCHA' AS expected, fn_br_remove_acentos('Cidade Gaúcha') AS actual;
SELECT 'MAE D''AGUA' AS expected, fn_br_remove_acentos('Mãe d''Água') AS actual;
