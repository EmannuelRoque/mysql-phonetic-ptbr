# Algoritmo de Normalização

Versão inicial do MVP:

1. Receber texto bruto.
2. Aplicar `TRIM`.
3. Converter para maiúsculas.
4. Remover acentos.
5. Substituir pontuação comum por espaço.
6. Tratar apóstrofos em partículas como `D'`.
7. Remover partículas selecionadas quando fizer sentido para cidade.
8. Colapsar espaços repetidos.

Cuidados iniciais:

- não unir tokens de uma letra genericamente;
- preservar `E` em casos válidos como `ABREU E LIMA`;
- tratar `SANT ANA` como variante de `SANTANA` apenas em regra específica.
