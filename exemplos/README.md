# Exemplos

Trechos **ilustrativos e fictícios** do *Simulador de Cliques Turbo* (*Turbo Click Simulator*).
Eles mostram os padrões descritos em [`ARQUITETURA.md`](../ARQUITETURA.md), mas **não são o código do jogo**:
nomes, valores e fórmulas foram inventados para esta demonstração e não há IDs reais, chaves ou lógica sensível.

| Arquivo | Padrão demonstrado |
| --- | --- |
| [`01_config_exemplo.lua`](01_config_exemplo.lua) | Módulo `Config` compartilhado: fonte única de verdade lida por cliente e servidor. |
| [`02_validacao_servidor.lua`](02_validacao_servidor.lua) | Servidor autoritativo: valida a entrada do cliente, cobra, responde e nunca deixa o estado "ocupado" preso. |
| [`03_sorteio_ponderado.lua`](03_sorteio_ponderado.lua) | Uma única função de chances usada pelo servidor (sorteio) e pela interface (porcentagem real). |
