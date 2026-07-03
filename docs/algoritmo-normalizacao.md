# Algoritmo de Normalizacao

Versao inicial do MVP:

1. Receber texto bruto.
2. Aplicar `TRIM`.
3. Converter para maiusculas.
4. Remover acentos.
5. Substituir pontuacao comum por espaco.
6. Tratar apostrofos em particulas como `D'`.
7. Remover particulas selecionadas quando fizer sentido para cidade.
8. Colapsar espacos repetidos.

Cuidados iniciais:

- nao unir tokens de uma letra genericamente;
- preservar `E` em casos validos como `ABREU E LIMA`;
- tratar `SANT ANA` como variante de `SANTANA` apenas em regra especifica.
