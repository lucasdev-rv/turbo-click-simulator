# 🥚 Simulador de Cliques Turbo — Portfólio

Jogo de clicker com pets para Roblox, pensado para celular, com interface 100% em português. Este repositório é uma vitrine do projeto: descreve o jogo, as mecânicas e a arquitetura. O código-fonte e o arquivo do jogo não são públicos.

---

## 📌 Visão geral

O jogador clica para ganhar moedas, abre ovos para conseguir pets, evolui, renasce (rebirth) e viaja por mundos temáticos cada vez mais difíceis, cada um com seus próprios ovos, bônus e pets exclusivos.

| Item | Detalhe |
| :--- | :--- |
| **Gênero** | Clicker / Idle / Colecionável (pets) |
| **Plataforma** | Roblox (celular, tablet e PC) |
| **Idioma** | Português (Brasil) |
| **Mundos** | 9 (Lobby + 8 mapas temáticos) |
| **Pets** | Mais de 75, em 6 raridades, com versão normal e dourada |
| **Ovos** | 14 ovos espalhados pelos mundos + 1 ovo premium |
| **Papel no projeto** | Design, programação, modelagem 3D dos pets, interface e balanceamento |

---

## 🎮 Principais mecânicas

### Cliques e progressão
* Clique manual com chance de crítico e limite de velocidade validado no servidor.
* Auto-clique (melhoria) e ganho passivo dos pets equipados.
* Rebirth em lotes: zera os cliques, mantém pets e melhorias e dá gemas e multiplicadores permanentes.
* Rank, missões, recompensa diária de 7 dias, códigos promocionais e poções temporárias.

### Mundos e portais
* Lobby central com portais de pedra que levam a oito mundos: Floresta, Inverno, Deserto, Selva, Doce, Vulcão, Oceano e Espaço.
* Cada mundo exige uma meta de cliques para ser liberado e dá um bônus de mundo crescente.
* Mapa de altura para teletransporte rápido entre mundos já liberados.

### Pets
* Seis raridades: Comum, Incomum, Épico, Lendário, Mítico e Secreto.
* Versão dourada de quase todos os pets, criada em máquinas de fusão (com tempo de espera ou com chance).
* Equipar vários pets de uma vez, equipar os melhores automaticamente, travar pets, excluir automático por raridade.
* Alimentar pets para subir de nível e encantamento (cristais e passivas sorteadas).
* Índex (coleção) com recompensas por mundo e bônus de sorte.
* Pets exclusivos do Ovo Carmesim, cujo poder é um bônus percentual sobre o melhor pet do jogador.

### Ovos
* Abertura de 1 até 8 ovos por vez (liberada por melhorias e gamepasses).
* Chances calculadas em um único lugar e usadas tanto pelo servidor (sorteio) quanto pela interface (mostrar as chances reais).
* Animações de abertura, incluindo uma animação especial com rachaduras na cor da raridade.

### Economia e loja
* Gemas: árvore de habilidades hexagonal, mais slots de pets, mais inventário, sorte, crítico e rebirth em lote.
* Loja de Robux com gamepasses (incubação, abrir 8 ovos, slots extras, sorte, super sorte e caçador de secretos) e produtos (ovos premium e expansão de inventário).

### Extras
* Baú diário com cooldown e recompensa proporcional à renda.
* Roleta, escavação no Deserto e máquinas especiais.
* Placares globais (Cliques, Ovos abertos e Rebirths) com avatar do primeiro colocado em pedestal.
* Menu de configurações (música, efeitos, desempenho, tema, esconder pets, etc.).

---

## 🧩 Sistemas implementados

* ✅ Salvamento de dados com trava de sessão (evita perder ou duplicar progresso entre servidores)
* ✅ Compras com Robux com recibo idempotente (não entrega duas vezes)
* ✅ Servidor autoritativo: cliques, sorteios, preços e posse de mundos são sempre validados no servidor
* ✅ Proteções contra abuso (limite de requisições, validação de distância, de mundo liberado e de pets travados)
* ✅ Interface adaptada para celular (escala automática, botões grandes)
* ✅ Opções de desempenho para aparelhos fracos
* ✅ Pipeline de criação de pets em 3D (veja abaixo)

---

## 🛠️ Tecnologias e ferramentas

| Área | Ferramenta |
| :--- | :--- |
| **Motor / editor** | Roblox Studio |
| **Linguagem** | Luau |
| **Persistência** | DataStoreService (com trava de sessão) |
| **Monetização** | Gamepasses e Developer Products (MarketplaceService) |
| **Modelagem 3D** | Blender (Python/bpy) com scripts próprios para gerar pets em estilo "cubo arredondado" |
| **Texturas** | Pintura procedural e texturas geradas, versão dourada separada |
| **Interface** | UI criada por código (`Instance.new`), com módulos reutilizáveis |
| **Apoio ao desenvolvimento** | Claude Code (assistente de IA) integrado ao Roblox Studio |

### Estilo visual dos pets
Todos os pets seguem o mesmo padrão: corpo arredondado em uma peça só, sem partes soltas, com olhos grandes no estilo anime. Os modelos são gerados por script no Blender, exportados em FBX e importados no Roblox.

---

## 📂 Conteúdo deste repositório

```text
turbo-click-simulator/
├── README.md          ← você está aqui
├── ARQUITETURA.md     ← como os sistemas se comunicam
├── exemplos/          ← 2 trechos curtos e genéricos de lógica
└── .gitignore         ← bloqueia arquivos do jogo (.rbxl, .rbxlx, etc.)
