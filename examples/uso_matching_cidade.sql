SELECT m.*
  FROM dim_municipio_example m
 WHERE m.uf = 'RS'
   AND m.cidade_norm = fn_br_norm_cidade('Sant''Ana do Livramento', 'RS');

SELECT m.*
  FROM dim_municipio_example m
 WHERE m.uf = 'RS'
   AND m.cidade_fonetica = fn_br_fonetica_ptbr(fn_br_norm_cidade('Sant''Ana do Livramento', 'RS'));
