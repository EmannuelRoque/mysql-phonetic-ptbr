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
