# Preferências globais do usuário

## OpenSpec: spec + implementação num PR; archive em PR separado

Toda mudança OpenSpec é entregue em dois PRs:

1. **Spec + implementação**: uma branch `<nome-base>` (sem sufixo de fase) e um PR, com as fases em commits separados: um commit para os artefatos da spec (proposal/design/specs/tasks) e um ou mais para a implementação, nessa ordem.
2. **Archive**: um PR próprio, aberto depois do merge da implementação, que roda `openspec archive` da change e de qualquer outra change pendente de arquivamento no repositório (incluindo criar a spec base quando faltar).

**Por quê:** em 2026-10-29 o usuário trocou três PRs empilhados (`-spec`/`-impl`/`-archive`) por um PR só; em 2026-11-10 tirou o archive desse PR porque ele dificulta a leitura do diff. Vale para toda change OpenSpec em qualquer repositório.

**Como aplicar:** não incluir `openspec archive` no PR da change. Não criar stacks com GH Stack para changes OpenSpec.
