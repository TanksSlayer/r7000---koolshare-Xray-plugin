# Changelog

## 4.0.5-xray.1

- 内核由 V2Ray 替换为 Xray-core v26.11.9（ARM32 v5），删除 v2ctl。
- 配置生成改为 Xray `inbounds`/`outbounds` 格式。
- 新增 VLESS、Trojan、Shadowsocks 出站，REALITY，grpc/httpupgrade/xhttp 传输。
- 网页新增对应表单字段，并支持以链接（vmess/vless/trojan/ss）或 JSON 导入节点。
- 内核更新脚本改为从 XTLS/Xray-core 获取。
- 订阅/备份脚本支持新字段。
