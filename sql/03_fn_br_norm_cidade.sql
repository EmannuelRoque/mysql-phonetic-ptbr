DROP FUNCTION IF EXISTS fn_br_norm_cidade;
DELIMITER $$
CREATE FUNCTION fn_br_norm_cidade(p_cidade VARCHAR(255), p_uf CHAR(2))
RETURNS VARCHAR(255)
DETERMINISTIC
NO SQL
BEGIN
  DECLARE v_txt VARCHAR(255);

  IF p_cidade IS NULL THEN
    RETURN NULL;
  END IF;

  SET v_txt = fn_br_norm_texto(p_cidade);
  SET v_txt = CONCAT(' ', v_txt, ' ');

  SET v_txt = REPLACE(v_txt, ' D OESTE ', ' OESTE ');
  SET v_txt = REPLACE(v_txt, ' D AGUA ', ' AGUA ');
  SET v_txt = REPLACE(v_txt, ' D ARCO ', ' ARCO ');

  SET v_txt = REPLACE(v_txt, ' CIDADE DE ', ' ');
  SET v_txt = REPLACE(v_txt, ' DAS ', ' ');
  SET v_txt = REPLACE(v_txt, ' DOS ', ' ');
  SET v_txt = REPLACE(v_txt, ' DA ', ' ');
  SET v_txt = REPLACE(v_txt, ' DO ', ' ');
  SET v_txt = REPLACE(v_txt, ' DE ', ' ');

  SET v_txt = REPLACE(v_txt, ' SANT ANA ', ' SANTANA ');
  SET v_txt = REPLACE(v_txt, '  ', ' ');
  SET v_txt = REPLACE(v_txt, '  ', ' ');
  SET v_txt = REPLACE(v_txt, '  ', ' ');
  SET v_txt = TRIM(v_txt);

  RETURN v_txt;
END$$
DELIMITER ;
