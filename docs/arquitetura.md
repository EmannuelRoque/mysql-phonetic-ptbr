# Arquitetura

O MVP parte de quatro camadas simples:

1. `fn_br_remove_acentos`: remove acentos e cedilha.
2. `fn_br_norm_texto`: caixa alta, limpeza basica e normalizacao de espacos.
3. `fn_br_norm_cidade`: aplica heuristicas iniciais para nomes de cidade e particulas.
4. `fn_br_fonetica_ptbr`: gera uma chave fonetica auxiliar pragmatica.

Arquivos de apoio:

- `sql/install_all.sql`: instalacao ordenada.
- `sql/uninstall_all.sql`: remocao ordenada.
- `tests/`: regressao e verificacao manual.
- `examples/`: uso recomendado com materializacao e matching.
