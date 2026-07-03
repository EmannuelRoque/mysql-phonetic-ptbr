SELECT '02_test_norm_texto' AS test_name;

SELECT 'SAO PAULO' AS expected,
       fn_br_norm_texto('São Paulo') AS actual;

SELECT 'SANTA BARBARA D OESTE' AS expected,
       fn_br_norm_texto('Santa Bárbara d''Oeste') AS actual;

SELECT 'OLHO D AGUA DAS FLORES' AS expected,
       fn_br_norm_texto('Olho d''Água das Flores') AS actual;

SELECT 'SANT ANA DO LIVRAMENTO' AS expected,
       fn_br_norm_texto('Sant Ana do Livramento') AS actual;
