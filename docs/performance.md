# Performance

Diretrizes iniciais:

- evitar depender de cálculo em tempo de consulta para grandes volumes;
- preferir coluna materializada preenchida por carga ou aplicação;
- indexar `UF + cidade_norm` para match exato;
- usar chave fonética apenas para reduzir candidatos, não para comparar o universo inteiro sempre.

O projeto deve priorizar SQL legível e estável no MVP. Otimizações devem vir acompanhadas de benchmark e validação funcional.
