# OPENCODE

Este projeto deve manter compatibilidade com MySQL/Percona 5.7+.

Não usar REGEXP_REPLACE.
Não usar recursos exclusivos do MySQL 8.
Não depender de UDF nativa.
Não copiar código de projetos externos sem verificar licença.
Preferir SQL explícito, auditável e testável.
Toda mudança de regra deve incluir teste de regressão.
A função fonética é chave auxiliar, não decisão final de matching.
Em produção, recomendar coluna materializada e índice.
Permitir apenas reutilização de funções-base: `fn_br_norm_texto()` pode chamar `fn_br_remove_acentos()`, `fn_br_norm_cidade()` pode chamar `fn_br_norm_texto()`, `fn_br_fonetica_ptbr()` pode chamar `fn_br_norm_texto()`.
`fn_br_fonetica_ptbr()` não deve chamar `fn_br_norm_cidade()`.
