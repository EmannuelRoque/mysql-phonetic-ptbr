# Performance

Diretrizes iniciais:

- evitar depender de calculo em tempo de consulta para grandes volumes;
- preferir coluna materializada preenchida por carga ou aplicacao;
- indexar `UF + cidade_norm` para match exato;
- usar chave fonetica apenas para reduzir candidatos, nao para comparar o universo inteiro sempre.

O projeto deve priorizar SQL legivel e estavel no MVP. Otimizacoes devem vir acompanhadas de benchmark e validacao funcional.
