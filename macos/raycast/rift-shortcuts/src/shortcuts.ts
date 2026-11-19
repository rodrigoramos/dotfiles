// Fonte de dados da lista. Espelha ~/git/dotfiles/macos/rift/config.toml.
// Ao mudar um atalho no config.toml, atualize aqui também.

export type Shortcut = {
  group: string;
  action: string; // o que faz
  keys: string; // como digitar
  i3?: string; // equivalente no i3
  extra?: string; // detalhe mostrado no subtítulo
};

export const SHORTCUTS: Shortcut[] = [
  // Janela
  { group: "Janela", action: "Abrir terminal (kitty)", keys: "⌥ Enter", i3: "$mod+Return" },
  { group: "Janela", action: "Fechar janela", keys: "⌥ Q", i3: "$mod+q" },
  { group: "Janela", action: "Tela cheia", keys: "⌥ ⇧ F", i3: "$mod+f" },
  { group: "Janela", action: "Alternar flutuante", keys: "⌥ Space", i3: "$mod+Shift+space" },
  { group: "Janela", action: "Alternar orientação (toggle split)", keys: "⌥ ⇧ I", i3: "$mod+e" },
  { group: "Janela", action: "Foco entre janela tiled e flutuante", keys: "⌥ ⇧ Enter", i3: "$mod+space" },
  { group: "Janela", action: "Ligar/desligar tiling neste Space", keys: "⌥ Z" },
  { group: "Janela", action: "Recarregar config do Rift", keys: "⌥ ⇧ R", i3: "$mod+Shift+c" },
  { group: "Janela", action: "Arrastar janela (mover, drop troca)", keys: "fn + mouse" },

  // Dentro do workspace
  { group: "Dentro do workspace", action: "Foco: esquerda, direita, cima, baixo", keys: "⌥ ← → ↑ ↓", i3: "$mod+setas" },
  { group: "Dentro do workspace", action: "Mover janela com as setas", keys: "⌥ ⌃ ← → ↑ ↓", i3: "$mod+Shift+setas" },
  {
    group: "Dentro do workspace",
    action: "Mover janela estilo vim",
    keys: "⌥ ⇧ J K L ;",
    i3: "$mod+Shift+j/k/l/ç",
    extra: "J esquerda, K baixo, L cima, ; direita",
  },
  { group: "Dentro do workspace", action: "Juntar com a janela vizinha (split)", keys: "⌥ ⌃ ⇧ ← → ↑ ↓", i3: "split h/v" },
  { group: "Dentro do workspace", action: "Desfazer junção", keys: "⌥ ⌃ ," },
  { group: "Dentro do workspace", action: "Empilhar container (stacking/tabbed)", keys: "⌥ S", i3: "layout stacking / tabbed" },
  { group: "Dentro do workspace", action: "Subir na árvore (focus parent)", keys: "⌥ A", i3: "$mod+a" },
  { group: "Dentro do workspace", action: "Descer na árvore (focus child)", keys: "⌥ ⇧ A", i3: "$mod+Shift+a" },
  { group: "Dentro do workspace", action: "Igualar tamanhos dos splits", keys: "⌥ ⇧ =" },

  // Redimensionar
  { group: "Redimensionar", action: "Redimensionar janela", keys: "⌥ ⇧ ← → ↑ ↓", extra: "← e ↑ encolhem, → e ↓ crescem" },
  {
    group: "Redimensionar",
    action: "Modo resize",
    keys: "⌥ R",
    i3: "$mod+r",
    extra: "Dentro: J K L ; ou setas. Enter, Esc ou ⌥ R saem",
  },

  // Workspaces
  { group: "Workspaces", action: "Ir ao workspace 1 a 10", keys: "⌥ 1 … 9 0", i3: "$mod+1..0" },
  { group: "Workspaces", action: "Próximo / anterior workspace", keys: "⌥ Tab · ⌥ ⇧ Tab", i3: "$mod+j / $mod+k" },
  {
    group: "Workspaces",
    action: "Próximo / anterior workspace (estilo i3)",
    keys: "⌥ J · ⌥ K",
    i3: "next_on_output / prev_on_output",
    extra: "No Rift em modo global navega entre todos os monitores",
  },
  { group: "Workspaces", action: "Último workspace (back and forth)", keys: "⌥ B", i3: "$mod+b" },
  { group: "Workspaces", action: "Mover janela para o workspace N e seguir", keys: "⌥ ⇧ 1 … 0", i3: "$mod+Shift+1..0" },
  { group: "Workspaces", action: "Mover janela para o workspace N sem seguir", keys: "⌥ ⌃ 1 … 0" },
  {
    group: "Workspaces",
    action: "Workspaces fixos por monitor",
    keys: "—",
    extra: "1 MacBook, 3 LU28R55, 4 e 6 monitor em pé 27G64",
  },

  // Monitores
  {
    group: "Monitores",
    action: "Mover o workspace atual para outro monitor (modo)",
    keys: "⌥ ⇧ M, depois H J K L",
    i3: "$mod+Shift+m",
    extra: "H esquerda, J baixo, K cima, L direita (com wrap)",
  },
  { group: "Monitores", action: "Workspace para o MacBook", keys: "⌥ ⇧ M, depois N", i3: "n → eDP1" },
  { group: "Monitores", action: "Workspace para o monitor em pé (27G64)", keys: "⌥ ⇧ M, depois P", i3: "p → DP1-3" },
  { group: "Monitores", action: "Workspace para o LU28R55", keys: "⌥ ⇧ M, depois M" },
  {
    group: "Monitores",
    action: "Mover só a janela focada para outro monitor (modo)",
    keys: "⌥ ⌃ M, depois H J K L N P M",
    extra: "Mesmas teclas do modo de workspace",
  },
  { group: "Monitores", action: "Focar monitor à esquerda / à direita", keys: "⌥ , · ⌥ ." },
];
