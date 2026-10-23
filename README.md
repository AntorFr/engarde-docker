# engarde-docker

Container image and laptop tooling for [engarde](https://github.com/porech/engarde):
a WireGuard tunnel that survives flaky links by sending **every packet over every
available connection**. The first copy to arrive wins; WireGuard itself discards
the duplicates.

Built for a laptop on a train (4G + phone tethering + onboard Wi-Fi) reaching a
WireGuard server at home, but nothing here is specific to that setup.

```
laptop: WireGuard ─► engarde-client ─┬─ link A ─┐
                                     └─ link B ─┴─► engarde-server ─► WireGuard server
```

## Image

`ghcr.io/antorfr/engarde:X.Y.Z` — `engarde-server` only, built from a pinned
upstream commit (`ENGARDE_REF` in the [Dockerfile](Dockerfile); upstream has no
tagged releases). Runs as non-root.

| Port | Use |
|---|---|
| `59402/udp` | clients |
| `9001/tcp` | web manager (connected client addresses) |

It reads `/config/engarde.yml` (override with the first argument):

```yaml
server:
  listenAddr: "0.0.0.0:59402"
  dstAddr: "192.168.10.1:62704"   # the WireGuard server to relay to
  clientTimeout: 30               # keep above the clients' PersistentKeepalive
  webManager:
    listenAddr: "0.0.0.0:9001"
```

The server must see each link's **own** source address, otherwise replies can't
be sent back on every link: on Kubernetes, expose it with
`externalTrafficPolicy: Local` (see the `engarde` chart in
[smart-home-charts](https://github.com/AntorFr/smart-home-charts)).

## Laptop side (macOS)

```sh
client/train.sh
```

builds `engarde-client` for macOS arm64 in Docker on first run (nothing is
installed on the host), then runs it with [client/engarde.yml](client/engarde.yml).
Status page: <http://127.0.0.1:9001>.

Then switch WireGuard to a profile identical to the usual one except for:

```ini
[Peer]
Endpoint = 127.0.0.1:59401   # engarde-client instead of the server
PersistentKeepalive = 15     # keeps every link known to the server
```

### Caveats

- On macOS, engarde binds each socket to an interface's **address** but cannot
  pin the interface itself (Linux uses `SO_BINDTODEVICE`). Check on the status
  page that every link receives data.
- With a full tunnel (`AllowedIPs = 0.0.0.0/0`), macOS no longer excludes the
  server's address from the tunnel once the Endpoint is localhost. If traffic
  loops, exclude the server's public IP from `AllowedIPs`.
- Bandwidth use is multiplied by the number of links.

## Release

`git tag vX.Y.Z && git push --tags` publishes `ghcr.io/antorfr/engarde:X.Y.Z`
(multi-arch on stable tags) and a GitHub Release.

## License

engarde is GPL-2.0 ([upstream](https://github.com/porech/engarde)); this
repository only packages it.
