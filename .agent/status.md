# Status — engarde-docker
> MàJ : 2026-10-23

**État :** image serveur + client macOS construits et testés en local (aller-retour UDP via le relais) ; chart `engarde` 0.1.0 et manifeste homenode prêts en worktree, rien de publié.

**Prochaines étapes :**
- [ ] Publier : dépôt GitHub, tag v0.1.0, chart, manifeste, redirection UDP 59402 sur l'UDM
- [ ] Tester à la maison : l'UDM accepte-t-il le WireGuard relayé par le LAN ?
- [ ] Tester à la maison : macOS envoie-t-il bien une copie par interface (Wi-Fi + iPhone USB) ?
- [ ] Trajet du mardi 2026-10-27 : mesurer avec et sans engarde
- [ ] tmux dans l'image de Fury (homelab-sdlc-core) — à décider
