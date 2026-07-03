DROP TABLE IF EXISTS dim_municipio_example;

CREATE TABLE dim_municipio_example (
  id INT NOT NULL AUTO_INCREMENT,
  uf CHAR(2) NOT NULL,
  nome_municipio VARCHAR(255) NOT NULL,
  cidade_norm VARCHAR(255) NOT NULL,
  cidade_fonetica VARCHAR(255) NOT NULL,
  PRIMARY KEY (id),
  KEY ix_dim_municipio_example_uf_cidade_norm (uf, cidade_norm),
  KEY ix_dim_municipio_example_uf_cidade_fonetica (uf, cidade_fonetica)
);

INSERT INTO dim_municipio_example (
  uf,
  nome_municipio,
  cidade_norm,
  cidade_fonetica
) VALUES (
  'RS',
  'Santana do Livramento',
  fn_br_norm_cidade('Santana do Livramento', 'RS'),
  fn_br_fonetica_ptbr(fn_br_norm_cidade('Santana do Livramento', 'RS'))
);
