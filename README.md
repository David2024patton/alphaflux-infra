# alphaflux-infra

Server and network configuration for the AlphaFlux home server, kept out of the product
repository because it has a different audience and a different change cadence.

Three files, and each is small enough to read before running:

| File | What it does |
|---|---|
| `dmz-routing.sh` | Policy routing so replies to traffic arriving on the static WAN gateway leave by the same path. Marks the connection on ingress and restores the mark on output, with a rule pointing at table 100 |
| `dmz-routing.service` | The systemd oneshot unit that runs the script at boot |
| `setup-dmz-routing.sh` | Copies both into place, reloads systemd, enables and restarts the unit |

The problem this solves: the server is dual homed. Bulk traffic should use the fiber default
route, but a session that arrived over the static gateway has to reply over it too or the
connection is never established. See `docs/system-admin.md` in `alphaflux-docs` for the wider
server picture.

## Running it

```bash
sudo ./setup-dmz-routing.sh
systemctl is-active dmz-routing
```

## Note

`cradle-routing.service` was a second, conflicting attempt at the same thing. It was disabled
because two services fighting over the same routing table broke outbound access for every hosted
site. If you find it enabled, leave it disabled.
