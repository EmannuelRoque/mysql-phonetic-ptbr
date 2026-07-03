DROP FUNCTION IF EXISTS fn_br_fonetica_ptbr;
DELIMITER $$
CREATE FUNCTION fn_br_fonetica_ptbr(p_txt VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
NO SQL
BEGIN
  DECLARE v_txt VARCHAR(255);

  IF p_txt IS NULL THEN
    RETURN NULL;
  END IF;

  -- A fonetica depende apenas da normalizacao generica, nunca da normalizacao especifica de cidade.
  SET v_txt = fn_br_norm_texto(p_txt);

  SET v_txt = REPLACE(v_txt, 'PH', 'F');
  SET v_txt = REPLACE(v_txt, 'Y', 'I');
  SET v_txt = REPLACE(v_txt, 'W', 'V');
  SET v_txt = REPLACE(v_txt, 'CK', 'K');
  SET v_txt = REPLACE(v_txt, 'SS', 'S');
  SET v_txt = REPLACE(v_txt, 'RR', 'R');
  SET v_txt = REPLACE(v_txt, 'LH', 'LI');
  SET v_txt = REPLACE(v_txt, 'NH', 'NI');

  SET v_txt = REPLACE(v_txt, '  ', ' ');
  SET v_txt = TRIM(v_txt);

  RETURN v_txt;
END$$
DELIMITER ;
