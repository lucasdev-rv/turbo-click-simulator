# 🏗️ Arquitetura

Visão de alto nível de como o jogo é organizado. Nomes e detalhes internos foram simplificados de propósito.

## 1. Princípio central: servidor autoritativo

O **cliente só mostra e pede**; quem **decide** é sempre o servidor. O cliente nunca diz "ganhei X cliques"
ou "tirei esse pet": ele diz "quero abrir este ovo" e o servidor confere tudo antes de responder.

```mermaid
flowchart LR
    subgraph Cliente["Cliente (LocalScripts)"]
        UI[Interface e animações]
        IN[Entrada: toque / clique]
    end
    subgraph Servidor["Servidor (Script principal)"]
        V[Validação]
        L[Lógica de jogo]
        S[(Sessão do jogador em memória)]
    end
    DS[(DataStore)]
    CFG[[Módulo Config compartilhado]]

    IN -- RemoteEvent / RemoteFunction --> V
    V --> L --> S
    S -- atributos do jogador --> UI
    S <-- salva e carrega --> DS
    CFG --- UI
    CFG --- L
```

## 2. Organização dos módulos

| Local | Papel |
| --- | --- |
| `ReplicatedStorage` → **Config** | Fonte única de verdade: pets, ovos, mundos, preços, chances, fórmulas de poder e de custo. Lido por cliente **e** servidor. |
| `ReplicatedStorage` → módulos de UI | Telas reutilizáveis (inventário, loja, árvore de habilidades, diária, configurações). |
| `ReplicatedStorage` → modelos e ícones | Catálogos de modelos de pets, ícones normais e dourados. |
| `ServerScriptService` → **servidor principal** | Sessões, cliques, ovos, rebirth, mundos, loja, salvamento. |
| `ServerScriptService` → placares e extras | Placares globais e detalhes do mapa. |
| `StarterPlayerScripts` | Um LocalScript por tela ou sistema (cliques, pets, loja, portais, baú, placares...). |
| `Workspace` | Mapas, ovos, portais, placares e decoração. |

### Por que um Config compartilhado?
As **chances dos ovos** são calculadas por uma única função. O servidor a usa para sortear e o cliente a usa
para mostrar a porcentagem na tela, então o que o jogador vê é exatamente o que acontece.

## 3. Comunicação cliente ↔ servidor

- **RemoteFunction** para ações com resposta (abrir ovo, rebirth, comprar, equipar).
- **RemoteEvent** para avisos sem resposta (notificações, cliques, resultados de animação).
- **Atributos do jogador** para dados que a interface só precisa ler (cliques, gemas, mundo atual, bônus).
  O servidor escreve; o cliente apenas observa e atualiza a tela.
- Os remotes são **criados pelo servidor ao iniciar**, em um único ponto, e todos validam tipo e intervalo
  dos argumentos recebidos.

## 4. Fluxo principal de uma sessão

```mermaid
sequenceDiagram
    participant J as Jogador
    participant C as Cliente
    participant S as Servidor
    participant D as DataStore

    J->>S: Entra no jogo
    S->>D: Carrega dados (com trava de sessão)
    D-->>S: Dados do jogador
    S-->>C: Atributos iniciais (cliques, mundo, pets)
    loop Jogando
        J->>C: Clica / abre ovo / compra
        C->>S: Pedido (Remote)
        S->>S: Valida (limites, preço, mundo liberado, distância)
        S-->>C: Resultado + atributos atualizados
    end
    S->>D: Salva a cada 60 s
    J->>S: Sai do jogo
    S->>D: Salva e libera a trava
```

## 5. Fluxo de abertura de ovo

```mermaid
flowchart TD
    A[Cliente pede: abrir ovo] --> B{Servidor ocupado com este jogador?}
    B -- sim --> X[Recusa]
    B -- não --> C{Quantidade permitida?}
    C -- não --> X
    C -- sim --> D{Mundo do ovo liberado?}
    D -- não --> X
    D -- sim --> E{Perto do ovo, cliques e inventário ok?}
    E -- não --> X
    E -- sim --> F[Cobra o preço]
    F --> G[Sorteia pets com a mesma função de chances da interface]
    G --> H[Aplica exclusão automática e Index]
    H --> I[Recalcula poder e sincroniza]
    I --> J[Devolve o resultado para a animação]
```

## 6. Cálculo de ganho

```mermaid
flowchart LR
    R[Rebirths] --> G[Ganho por clique]
    M[Bônus do mundo atual] --> G
    P[Poder dos pets equipados] --> G
    U[Melhorias e árvore] --> G
    B[Poções e encantamentos] --> G
    G --> CL[Cliques / auto-clique / baú]
```

O bônus de mundo só vale em mundos que o jogador **já liberou**.

## 7. Dados e segurança

| Preocupação | Como é tratada |
| --- | --- |
| Perda ou duplicação de progresso | Trava de sessão ao salvar e carregar; falha no carregamento não deixa o jogador jogar "zerado". |
| Compras repetidas | Recibo idempotente: o mesmo recibo nunca entrega duas vezes. |
| Cliente adulterado | Servidor valida preço, distância, mundo liberado, taxa de cliques e propriedade dos itens. |
| Pets pagos ou trancados | Não podem ser consumidos por máquinas ou encantamento. |
| Estados travados | Operações críticas protegidas para sempre liberar o estado "ocupado". |
| Painel de desenvolvedor | Restrito a IDs autorizados e desligado na versão publicada. |

## 8. Pipeline de arte (fora do Roblox)

```mermaid
flowchart LR
    PY[Script Python no Blender] --> M[Modelo único + textura]
    M --> FBX[Exporta FBX]
    FBX --> UP[Upload pelo Open Cloud]
    UP --> RB[Pet no jogo: escala, efeitos, ícones]
```

Os pets são gerados por parâmetros (cores, chifres, caudas, auréolas, etc.), o que permite criar novos pets
mantendo o mesmo estilo visual rapidamente.
