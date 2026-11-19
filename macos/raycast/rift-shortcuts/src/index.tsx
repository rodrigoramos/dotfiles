import { Action, ActionPanel, Icon, List } from "@raycast/api";
import { SHORTCUTS, Shortcut } from "./shortcuts";

// Teclas que o usuário digita na busca ("alt shift m", "option", "cmd") também casam.
function keywordsFor(s: Shortcut): string[] {
  const spoken = s.keys
    .replace(/⌥/g, "alt option")
    .replace(/⇧/g, "shift")
    .replace(/⌃/g, "ctrl control")
    .replace(/←/g, "left esquerda")
    .replace(/→/g, "right direita")
    .replace(/↑/g, "up cima")
    .replace(/↓/g, "down baixo");
  return [s.group, spoken, s.i3 ?? "", s.extra ?? "", "i3", "rift"].filter(Boolean);
}

export default function Command() {
  const groups = Array.from(new Set(SHORTCUTS.map((s) => s.group)));

  return (
    <List searchBarPlaceholder="Buscar atalho: mover workspace, monitor, split, alt shift m…" isShowingDetail={false}>
      {groups.map((group) => (
        <List.Section key={group} title={group}>
          {SHORTCUTS.filter((s) => s.group === group).map((s) => (
            <List.Item
              key={`${group}-${s.action}-${s.keys}`}
              icon={Icon.Keyboard}
              title={s.action}
              subtitle={[s.extra, s.i3 ? `i3: ${s.i3}` : undefined].filter(Boolean).join("  ·  ")}
              keywords={keywordsFor(s)}
              accessories={[{ tag: s.keys }]}
              actions={
                <ActionPanel>
                  <Action.CopyToClipboard title="Copiar atalho" content={s.keys} />
                  <Action.CopyToClipboard title="Copiar ação e atalho" content={`${s.action}: ${s.keys}`} />
                </ActionPanel>
              }
            />
          ))}
        </List.Section>
      ))}
    </List>
  );
}
