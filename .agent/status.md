# Status — engarde-docker
> MàJ : 2026-10-24

**État :** EN PAUSE. Image `ghcr.io/antorfr/engarde:0.1.0` et chart `engarde` 0.1.0 publiés, branchés nulle part. Le relais sur homenode a été retiré : refus de toute redirection de port WAN → LAN. Prérequis posé par l'utilisateur : une DMZ sur machine physique dédiée, sans accès au LAN.

**Acquis (testé le 2026-10-23) :** relais → WireGuard de l'UDM par le réseau interne OK ; IP source préservée avec `externalTrafficPolicy: Local` ; client macOS compilé et fonctionnel.

**Prochaines étapes :**
- [ ] (utilisateur) Monter la DMZ : machine physique dédiée, pare-feu UDM DMZ → seulement UDP 62704 (porte WireGuard)
- [ ] Déployer le relais sur la machine DMZ (même image), `dstAddr` = porte WireGuard de l'UDM
- [ ] Tester : macOS envoie-t-il bien une copie par interface (Wi-Fi + iPhone USB, câble data) ?
- [ ] Tester la boucle avec Endpoint 127.0.0.1 en full tunnel ; sinon exclure l'IP du relais d'AllowedIPs
- [ ] tmux dans l'image de Fury (homelab-sdlc-core) — recommandé, à valider
