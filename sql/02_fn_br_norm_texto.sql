DROP FUNCTION IF EXISTS fn_br_norm_texto;
DELIMITER $$
CREATE FUNCTION fn_br_norm_texto(p_txt VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
NO SQL
BEGIN
  DECLARE v_txt VARCHAR(255);

  IF p_txt IS NULL THEN
    RETURN NULL;
  END IF;

  SET v_txt = fn_br_remove_acentos(TRIM(p_txt));
  SET v_txt = UPPER(v_txt);

  SET v_txt = REPLACE(v_txt, '.', ' ');
  SET v_txt = REPLACE(v_txt, ',', ' ');
  SET v_txt = REPLACE(v_txt, ';', ' ');
  SET v_txt = REPLACE(v_txt, ':', ' ');
  SET v_txt = REPLACE(v_txt, '-', ' ');
  SET v_txt = REPLACE(v_txt, '/', ' ');
  SET v_txt = REPLACE(v_txt, '\\', ' ');
  SET v_txt = REPLACE(v_txt, '(', ' ');
  SET v_txt = REPLACE(v_txt, ')', ' ');
  SET v_txt = REPLACE(v_txt, '[', ' ');
  SET v_txt = REPLACE(v_txt, ']', ' ');
  SET v_txt = REPLACE(v_txt, '{', ' ');
  SET v_txt = REPLACE(v_txt, '}', ' ');
  SET v_txt = REPLACE(v_txt, '"', ' ');
  SET v_txt = REPLACE(v_txt, '''', ' ');

  SET v_txt = REPLACE(v_txt, '  ', ' ');
  SET v_txt = REPLACE(v_txt, '  ', ' ');
  SET v_txt = REPLACE(v_txt, '  ', ' ');
  SET v_txt = TRIM(v_txt);

  RETURN v_txt;
END$$
DELIMITER ;
