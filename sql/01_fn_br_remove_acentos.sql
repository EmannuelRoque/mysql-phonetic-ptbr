DROP FUNCTION IF EXISTS fn_br_remove_acentos;
DELIMITER $$
CREATE FUNCTION fn_br_remove_acentos(p_txt VARCHAR(255))
RETURNS VARCHAR(255)
DETERMINISTIC
NO SQL
BEGIN
  DECLARE v_txt VARCHAR(255);

  IF p_txt IS NULL THEN
    RETURN NULL;
  END IF;

  SET v_txt = p_txt;

  SET v_txt = REPLACE(v_txt, 'Á', 'A');
  SET v_txt = REPLACE(v_txt, 'À', 'A');
  SET v_txt = REPLACE(v_txt, 'Ã', 'A');
  SET v_txt = REPLACE(v_txt, 'Â', 'A');
  SET v_txt = REPLACE(v_txt, 'Ä', 'A');
  SET v_txt = REPLACE(v_txt, 'á', 'A');
  SET v_txt = REPLACE(v_txt, 'à', 'A');
  SET v_txt = REPLACE(v_txt, 'ã', 'A');
  SET v_txt = REPLACE(v_txt, 'â', 'A');
  SET v_txt = REPLACE(v_txt, 'ä', 'A');

  SET v_txt = REPLACE(v_txt, 'É', 'E');
  SET v_txt = REPLACE(v_txt, 'È', 'E');
  SET v_txt = REPLACE(v_txt, 'Ê', 'E');
  SET v_txt = REPLACE(v_txt, 'Ë', 'E');
  SET v_txt = REPLACE(v_txt, 'é', 'E');
  SET v_txt = REPLACE(v_txt, 'è', 'E');
  SET v_txt = REPLACE(v_txt, 'ê', 'E');
  SET v_txt = REPLACE(v_txt, 'ë', 'E');

  SET v_txt = REPLACE(v_txt, 'Í', 'I');
  SET v_txt = REPLACE(v_txt, 'Ì', 'I');
  SET v_txt = REPLACE(v_txt, 'Î', 'I');
  SET v_txt = REPLACE(v_txt, 'Ï', 'I');
  SET v_txt = REPLACE(v_txt, 'í', 'I');
  SET v_txt = REPLACE(v_txt, 'ì', 'I');
  SET v_txt = REPLACE(v_txt, 'î', 'I');
  SET v_txt = REPLACE(v_txt, 'ï', 'I');

  SET v_txt = REPLACE(v_txt, 'Ó', 'O');
  SET v_txt = REPLACE(v_txt, 'Ò', 'O');
  SET v_txt = REPLACE(v_txt, 'Õ', 'O');
  SET v_txt = REPLACE(v_txt, 'Ô', 'O');
  SET v_txt = REPLACE(v_txt, 'Ö', 'O');
  SET v_txt = REPLACE(v_txt, 'ó', 'O');
  SET v_txt = REPLACE(v_txt, 'ò', 'O');
  SET v_txt = REPLACE(v_txt, 'õ', 'O');
  SET v_txt = REPLACE(v_txt, 'ô', 'O');
  SET v_txt = REPLACE(v_txt, 'ö', 'O');

  SET v_txt = REPLACE(v_txt, 'Ú', 'U');
  SET v_txt = REPLACE(v_txt, 'Ù', 'U');
  SET v_txt = REPLACE(v_txt, 'Û', 'U');
  SET v_txt = REPLACE(v_txt, 'Ü', 'U');
  SET v_txt = REPLACE(v_txt, 'ú', 'U');
  SET v_txt = REPLACE(v_txt, 'ù', 'U');
  SET v_txt = REPLACE(v_txt, 'û', 'U');
  SET v_txt = REPLACE(v_txt, 'ü', 'U');

  SET v_txt = REPLACE(v_txt, 'Ç', 'C');
  SET v_txt = REPLACE(v_txt, 'ç', 'C');

  RETURN UPPER(v_txt);
END$$
DELIMITER ;
