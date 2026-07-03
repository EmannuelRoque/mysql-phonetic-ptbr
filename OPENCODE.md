# OPENCODE

Este projeto deve manter compatibilidade com MySQL/Percona 5.7+.

Nao usar REGEXP_REPLACE.
Nao usar recursos exclusivos do MySQL 8.
Nao depender de UDF nativa.
Nao copiar codigo de projetos externos sem verificar licenca.
Preferir SQL explicito, auditavel e testavel.
Toda mudanca de regra deve incluir teste de regressao.
A funcao fonetica e chave auxiliar, nao decisao final de matching.
Em producao, recomendar coluna materializada e indice.
Permitir apenas reutilizacao de funcoes-base: `fn_br_norm_texto()` pode chamar `fn_br_remove_acentos()`, `fn_br_norm_cidade()` pode chamar `fn_br_norm_texto()`, `fn_br_fonetica_ptbr()` pode chamar `fn_br_norm_texto()`.
`fn_br_fonetica_ptbr()` nao deve chamar `fn_br_norm_cidade()`.
