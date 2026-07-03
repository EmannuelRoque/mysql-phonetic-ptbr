# Arquitetura

O MVP parte de quatro camadas simples:

1. `fn_br_remove_acentos`: remove acentos e cedilha.
2. `fn_br_norm_texto`: caixa alta, limpeza básica e normalização de espaços.
3. `fn_br_norm_cidade`: aplica heurísticas iniciais para nomes de cidade e partículas.
4. `fn_br_fonetica_ptbr`: gera uma chave fonética auxiliar pragmática.

Dependências internas permitidas:

- `fn_br_norm_texto()` -> `fn_br_remove_acentos()`
- `fn_br_norm_cidade()` -> `fn_br_norm_texto()`
- `fn_br_fonetica_ptbr()` -> `fn_br_norm_texto()`

Dependência interna proibida:

- `fn_br_fonetica_ptbr()` -> `fn_br_norm_cidade()`

Isso evita acoplar a chave fonética a regras específicas de município e preserva o uso genérico para outros domínios.

Arquivos de apoio:

- `sql/install_all.sql`: instalação ordenada.
- `sql/uninstall_all.sql`: remocao ordenada.
- `tests/`: regressão e verificação manual.
- `examples/`: uso recomendado com materialização e matching.
