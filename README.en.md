# r7000 Merlin koolshare Xray plugin

[中文](README.md) | English

A modified build of koolshare **fancyss (4.0.5)** for ARM Asuswrt-Merlin / koolshare firmware such as the Netgear R7000.
The legacy V2Ray 3.x/4.x core is replaced with **Xray-core**, so the V2Ray side supports current protocols and transports.

## Features

| Category | Supported |
| --- | --- |
| Outbound protocols | VMess, VLESS (incl. `xtls-rprx-vision`, encryption), Trojan, Shadowsocks (incl. SS2022) |
| Transports | tcp, kcp, ws, h2, grpc, httpupgrade, xhttp (quic removed) |
| Security | none, tls (SNI / ALPN / fingerprint / allowInsecure), **REALITY** (publicKey / shortId / spiderX) |
| Other | Mux (auto-disabled with flow, reality, grpc, xhttp), dokodemo-door transparent proxy, DNS forwarding |
| Import | Paste `vmess://`, `vless://`, `trojan://`, `ss://` links, or a full JSON / `outbound` / single outbound, in the web UI |
| Core update | "Update V2ray binary" in the UI downloads the latest `Xray-linux-arm32-v5` from XTLS/Xray-core and verifies its MD5 |

The original SS / SSR / koolgame / KCP / UDPspeeder / udp2raw features are unchanged.

## Installation

1. Download `shadowsocks_4.0.5_xray.tar.gz` from [Releases](../../releases).
2. In the Merlin/koolshare Software Center, use "Offline install" and upload the file.
3. Open the plugin, choose node type V2ray, pick a protocol and fill in the form, or paste a link/JSON into the JSON box.

## Notes

- The Xray binary is about 34 MB; devices with small storage may not fit it (you can compress it with UPX).
- Plugin parameters in `ss://` links are ignored.
- Imported links are converted to JSON and "use JSON" is ticked automatically; form fields are not filled in.
- This build has **not been fully tested on real hardware**. Back up your configuration first.
- The "version date" field in the UI now shows Xray version/commit info.

## Layout

See [SOURCE.md](SOURCE.md) (in Chinese) for the source layout, and [CHANGELOG.md](CHANGELOG.md) for changes.

## License and credits

Upstream: koolshare fancyss. Core: [XTLS/Xray-core](https://github.com/XTLS/Xray-core) (MPL-2.0). Other binaries are carried over from the original package.
