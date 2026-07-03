# Algoritmo de Fonetica

A funcao `fn_br_fonetica_ptbr` deve ser entendida como chave auxiliar, nao como algoritmo canonico oficial.

Objetivo inicial:

- reduzir variacao grafica obvia;
- manter implementacao SQL pura e simples;
- ser boa o bastante para filtrar candidatos antes de um ranking final.

Primeiras ideias documentadas para evolucao:

- remover vogais apos a primeira letra;
- colapsar repeticoes;
- aproximar grupos consonantais frequentes do portugues brasileiro;
- avaliar tratamento especifico para `NH`, `LH`, `CH`, `SS`, `SC`, `XC`, `GE`, `GI`.

O stub atual e conservador e serve apenas como base instalavel e testavel.
