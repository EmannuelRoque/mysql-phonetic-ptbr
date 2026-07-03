SELECT '05_regressao_santana_livramento' AS test_name;

SELECT fn_br_norm_cidade('Sant''Ana do Livramento', 'RS') AS sant_ana;
SELECT fn_br_norm_cidade('Santana do Livramento', 'RS') AS santana;
SELECT fn_br_norm_cidade('Sant Ana do Livramento', 'RS') AS sant_ana_separado;

SELECT CASE
         WHEN fn_br_norm_cidade('Sant''Ana do Livramento', 'RS') = 'SANTANA LIVRAMENTO'
          AND fn_br_norm_cidade('Santana do Livramento', 'RS') = 'SANTANA LIVRAMENTO'
          AND fn_br_norm_cidade('Sant Ana do Livramento', 'RS') = 'SANTANA LIVRAMENTO'
         THEN 'OK'
         ELSE 'FALHOU'
       END AS regressao_status;
