# r7000 梅林 koolshare Xray plugin

基于 koolshare **fancyss（科学上网）4.0.5** 的修改版，适用于 Netgear R7000 等 ARM 梅林（Merlin）/ koolshare 固件。
将原 V2Ray 3.x/4.x 内核替换为 **Xray-core**，使 V2Ray 一侧支持最新协议与传输方式。

## 功能

| 类别 | 支持 |
| --- | --- |
| 出站协议 | VMess、VLESS（含 `xtls-rprx-vision`、encryption）、Trojan、Shadowsocks（含 SS2022） |
| 传输 | tcp、kcp、ws、h2、grpc、httpupgrade、xhttp（quic 已移除） |
| 安全 | none、tls（SNI / ALPN / 指纹 / allowInsecure）、**REALITY**（publicKey / shortId / spiderX） |
| 其他 | Mux（flow、reality、grpc、xhttp 时自动关闭）、dokodemo-door 透明代理、DNS 转发 |
| 导入 | 网页中粘贴 `vmess://`、`vless://`、`trojan://`、`ss://` 链接，或完整 JSON / `outbound` / 单个 outbound，均可导入 |
| 内核更新 | 网页“更新 V2ray 二进制”会从 XTLS/Xray-core 最新 release 下载 `Xray-linux-arm32-v5` 并校验 MD5 |

原插件的 SS / SSR / koolgame / KCP / UDPspeeder / udp2raw 等功能保持不变。

## 安装

1. 到 [Releases](../../releases) 下载 `shadowsocks_4.0.5_xray.tar.gz`。
2. 在梅林/koolshare 的“软件中心”→“离线安装”中上传该文件安装。
3. 进入“科学上网”，节点类型选 V2ray 后，选择协议并填写，或在 JSON 框粘贴链接/JSON。

## 注意

- Xray 二进制约 34 MB，容量较小的路由器可能装不下（可自行用 UPX 压缩）。
- `ss://` 链接中的 plugin 参数会被忽略。
- 导入链接会转换为 JSON 并自动勾选“使用 JSON”，不会回填表单字段。
- 本修改版**未在真机上完整测试**，使用前请备份配置。
- 界面中“版本日期”一栏现显示 Xray 的版本/提交信息。

## 目录

见 [SOURCE.md](SOURCE.md)（源码说明）。版本变更见 [CHANGELOG.md](CHANGELOG.md)。

## 许可与来源

上游：koolshare fancyss；内核：[XTLS/Xray-core](https://github.com/XTLS/Xray-core)（MPL-2.0）。其余二进制沿用原包。
