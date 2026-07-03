ALTER TABLE cadastro_endereco
  ADD COLUMN cidade_norm VARCHAR(255),
  ADD COLUMN cidade_fonetica VARCHAR(255),
  ADD INDEX ix_cadastro_endereco_uf_cidade_norm (uf, cidade_norm),
  ADD INDEX ix_cadastro_endereco_uf_cidade_fonetica (uf, cidade_fonetica);

UPDATE cadastro_endereco
   SET cidade_norm = fn_br_norm_cidade(cidade, uf),
       cidade_fonetica = fn_br_fonetica_ptbr(fn_br_norm_cidade(cidade, uf));
