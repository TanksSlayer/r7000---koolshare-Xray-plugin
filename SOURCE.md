# 源码说明

`shadowsocks/` 即插件包的解包内容，打包命令：`tar -czf shadowsocks_4.0.5_xray.tar.gz shadowsocks`。

| 路径 | 说明 |
| --- | --- |
| `shadowsocks/install.sh` / `uninstall.sh` | 安装/卸载脚本；安装时清除旧的 v2ray 版本记录 |
| `shadowsocks/bin/v2ray` | **Xray-core v26.11.9**（linux-arm32-v5，原 `v2ctl` 已删除）；其余为原插件二进制 |
| `shadowsocks/ss/ssconfig.sh` | 主控脚本。`v2ray_make_outbound` / `v2ray_pick_outbound` / `v2ray_make_config` / `creat_v2ray_json` 生成 Xray 配置（`inbounds`/`outbounds`，socks 23456、dokodemo-door 3333、可选 DNS 7913），启动命令 `v2ray run -config=/koolshare/ss/v2ray.json` |
| `shadowsocks/scripts/ss_v2ray.sh` | 内核更新脚本：取 XTLS/Xray-core 最新 release，校验 MD5 后替换 |
| `shadowsocks/scripts/ss_online_update.sh` | 订阅/备份，已包含新增节点字段 |
| `shadowsocks/scripts/ss_pack.sh` | 打包脚本（不再复制 v2ctl） |
| `shadowsocks/webs/Main_Ss_Content.asp` | 网页界面：新增协议/流控/Reality/TLS 等表单、显隐逻辑（`v2rayExtraShow`）、链接转 JSON（`v2ray_uri_to_outbound`、`v2ray_link2json`） |

## 新增 dbus 字段（`ss_basic_*` / `ssconf_basic_*_N`）

`v2ray_protocol`、`v2ray_flow`、`v2ray_encryption`、`v2ray_password`、`v2ray_ssmethod`、`v2ray_sni`、`v2ray_alpn`、`v2ray_fingerprint`、`v2ray_reality_pbk`、`v2ray_reality_sid`、`v2ray_reality_spx`、`v2ray_allowinsecure`、`v2ray_xhttp_mode`；`v2ray_network` 增加 grpc/httpupgrade/xhttp，`v2ray_network_security` 增加 reality。

配置生成依赖 `jq`（仅使用 jq 1.5 兼容语法）。
