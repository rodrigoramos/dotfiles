---
name: prefere-crontab-para-agendamento
description: Rodrigo prefere crontab (não systemd timers) para tarefas agendadas locais
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3137cbb9-9ad2-4f7f-a908-41574241354c
---

Ao configurar tarefas agendadas na máquina local, usar **crontab**, não systemd user timers.

**Why:** O sistema já usa crontab para tarefas agendadas; Rodrigo rejeitou explicitamente o setup via systemd timer (jul/2026) pedindo cron no lugar.

**How to apply:** Para agendamentos locais, editar o crontab do usuário (`crontab -l` / `crontab -e`) em vez de criar units em `~/.config/systemd/user/`. Ver [[rotina-resumo-semanal-erros]].
