#!/bin/sh

# shadowsocks script for AM380 merlin firmware
# by sadog (sadoneli@gmail.com) from koolshare.cn
# 内核已切换为 Xray-core（兼容v2ray配置，支持vmess/vless/trojan/shadowsocks/reality/xtls-vision等全部协议）

eval `dbus export ss`
source /koolshare/scripts/base.sh
alias echo_date='echo 【$(TZ=UTC-8 date -R +%Y年%m月%d日\ %X)】:'
V2RAY_CONFIG_FILE="/koolshare/ss/v2ray.json"
XRAY_REPO="XTLS/Xray-core"
XRAY_ASSET="Xray-linux-arm32-v5.zip"
url_api="https://api.github.com/repos/$XRAY_REPO/releases/latest"
url_dl="https://github.com/$XRAY_REPO/releases/download"

fail_exit(){
	echo_date "==================================================================="
	echo XU6J03M6
	exit 1
}

get_latest_version(){
	rm -rf /tmp/v2ray_latest_info.txt
	echo_date "检测Xray最新版本..."
	curl --connect-timeout 8 -s "$url_api" | grep '"tag_name"' | head -n 1 | sed 's/.*"tag_name"[^"]*"\([^"]*\)".*/\1/' > /tmp/v2ray_latest_info.txt
	if [ -z "`cat /tmp/v2ray_latest_info.txt`" ];then
		echo_date "获取Xray最新版本信息失败，请检查你的网络！"
		fail_exit
	fi
	V2VERSION=`cat /tmp/v2ray_latest_info.txt | sed 's/v//g'`
	echo_date "检测到Xray最新版本：v$V2VERSION"
	if [ ! -f "/koolshare/bin/v2ray" ];then
		echo_date "v2ray安装文件丢失！重新下载！"
		CUR_VER="0"
	else
		CUR_VER=`v2ray -version 2>/dev/null | head -n 1 | cut -d " " -f2 | sed 's/v//g'`
		[ -z "$CUR_VER" ] && CUR_VER="0"
		echo_date "当前已安装版本：v$CUR_VER"
	fi
	COMP=`versioncmp $CUR_VER $V2VERSION`
	if [ "$COMP" == "1" ];then
		[ "$CUR_VER" != "0" ] && echo_date "已安装版本号低于最新版本，开始更新程序..."
		update_now v$V2VERSION
	else
		save_version
		echo_date "已安装版本已经是最新，退出更新程序!"
	fi
}

save_version(){
	V2RAY_LOCAL_VER=`/koolshare/bin/v2ray -version 2>/dev/null | head -n 1 | cut -d " " -f2`
	V2RAY_LOCAL_DATE=`/koolshare/bin/v2ray -version 2>/dev/null | head -n 1 | cut -d " " -f5`
	[ -n "$V2RAY_LOCAL_VER" ] && dbus set ss_basic_v2ray_version="$V2RAY_LOCAL_VER"
	[ -n "$V2RAY_LOCAL_DATE" ] && dbus set ss_basic_v2ray_date="$V2RAY_LOCAL_DATE"
}

update_now(){
	rm -rf /tmp/v2ray
	mkdir -p /tmp/v2ray && cd /tmp/v2ray

	echo_date "开始下载Xray程序：$XRAY_ASSET"
	wget --no-check-certificate --timeout=20 --tries=2 -O "$XRAY_ASSET" "$url_dl/$1/$XRAY_ASSET"
	if [ "$?" != "0" ];then
		echo_date "Xray下载失败，请检查你的网络！"
		fail_exit
	fi
	echo_date "开始下载校验文件：$XRAY_ASSET.dgst"
	wget --no-check-certificate --timeout=20 --tries=2 -qO "$XRAY_ASSET.dgst" "$url_dl/$1/$XRAY_ASSET.dgst"
	if [ "$?" != "0" ];then
		echo_date "校验文件下载失败！"
		fail_exit
	fi
	check_md5sum
}

check_md5sum(){
	cd /tmp/v2ray
	echo_date "校验下载的文件!"
	LOCAL_MD5=`md5sum "$XRAY_ASSET" | awk '{print $1}'`
	ONLINE_MD5=`grep -i '^MD5' "$XRAY_ASSET.dgst" | head -n 1 | sed 's/.*=[ ]*//' | tr -d '\r '`
	if [ -n "$ONLINE_MD5" ] && [ "$LOCAL_MD5"x = "$ONLINE_MD5"x ];then
		echo_date "文件校验通过!"
		install_binary
	else
		echo_date "校验未通过，可能是下载过程出现了什么问题，请检查你的网络！"
		fail_exit
	fi
}

install_binary(){
	cd /tmp/v2ray
	unzip -o "$XRAY_ASSET" xray >/dev/null 2>&1
	if [ ! -f "/tmp/v2ray/xray" ];then
		echo_date "解压Xray失败！"
		fail_exit
	fi
	echo_date "开始覆盖最新二进制!"
	if [ "`pidof v2ray`" ];then
		echo_date "为了保证更新正确，先关闭v2ray主进程... "
		killall v2ray >/dev/null 2>&1
		move_binary
		sleep 1
		start_v2ray
	else
		move_binary
	fi
}

move_binary(){
	echo_date "开始替换v2ray二进制文件... "
	mv /tmp/v2ray/xray /koolshare/bin/v2ray
	# 旧版v2ray内核专用的v2ctl，Xray不再需要
	rm -rf /koolshare/bin/v2ctl
	chmod +x /koolshare/bin/v2ray
	save_version
	echo_date "v2ray二进制文件替换成功... "
}

start_v2ray(){
	echo_date "开启v2ray进程... "
	cd /koolshare/bin
	export GOGC=30
	v2ray run -config=/koolshare/ss/v2ray.json >/dev/null 2>&1 &

	local i=10
	until [ -n "$V2PID" ]
	do
		i=$(($i-1))
		V2PID=`pidof v2ray`
		if [ "$i" -lt 1 ];then
			echo_date "v2ray进程启动失败！"
			fail_exit
		fi
		sleep 1
	done
	echo_date v2ray启动成功，pid：$V2PID
}

echo_date "==================================================================="
echo_date "                Xray程序更新(Shell by sadog)"
echo_date "==================================================================="
get_latest_version
echo_date "==================================================================="
