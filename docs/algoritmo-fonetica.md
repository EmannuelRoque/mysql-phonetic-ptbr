# Algoritmo de Fonética

A função `fn_br_fonetica_ptbr` deve ser entendida como chave auxiliar, não como algoritmo canônico oficial.

Restrição de arquitetura:

- `fn_br_fonetica_ptbr()` pode reutilizar `fn_br_norm_texto()`.
- `fn_br_fonetica_ptbr()` não deve depender de `fn_br_norm_cidade()`.

Motivo: a fonética precisa permanecer genérica para cidade, rua, pessoa e razão social, sem herdar heurísticas municipais.

Objetivo inicial:

- reduzir variação gráfica óbvia;
- manter implementação SQL pura e simples;
- ser boa o bastante para filtrar candidatos antes de um ranking final.

Primeiras ideias documentadas para evolução:

- remover vogais após a primeira letra;
- colapsar repetições;
- aproximar grupos consonantais frequentes do português brasileiro;
- avaliar tratamento específico para `NH`, `LH`, `CH`, `SS`, `SC`, `XC`, `GE`, `GI`.

O stub atual é conservador e serve apenas como base instalável e testável.

Veja também `docs/especificacao-fonetica.md` para o contrato funcional e o corpus-alvo de evolução.
