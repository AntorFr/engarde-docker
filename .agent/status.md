# Status — engarde-docker
> MàJ : 2026-10-23

**État :** image 0.1.0 publiée, chart `engarde` 0.1.0 publié, relais déployé sur homenode (infra, UDP 59402, IP source préservée vérifiée). Côté Mac et UDM : rien encore.

**Prochaines étapes :**
- [ ] Redirection UDP 59402 WAN → homenode (192.168.10.11) sur l'UDM
- [ ] Profil WireGuard « Train » sur le Mac
- [ ] Tester à la maison : l'UDM accepte-t-il le WireGuard relayé par le LAN ?
- [ ] Tester à la maison : macOS envoie-t-il bien une copie par interface (Wi-Fi + iPhone USB) ?
- [ ] Trajet du mardi 2026-10-27 : mesurer avec et sans engarde
- [ ] tmux dans l'image de Fury (homelab-sdlc-core) — à décider
