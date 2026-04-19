#!/bin/sh
set -e

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
IPK_DIR="${SCRIPT_DIR}/ipk"

if ! command -v opkg >/dev/null 2>&1; then
  echo "错误：未找到 opkg，当前系统不像是 OpenWrt / iStoreOS。"
  exit 1
fi

if [ ! -d "$IPK_DIR" ]; then
  echo "错误：未找到 ipk 目录。"
  exit 1
fi

echo "==> 更新软件包索引"
opkg update || true

echo "==> 先尝试整包安装"
if opkg install "$IPK_DIR"/*.ipk; then
  echo "==> 批量安装成功"
else
  echo "==> 批量安装失败，开始分阶段安装"

  # 先装基础库/界面相关
  for pkg in \
    "$IPK_DIR"/luci-lib-*.ipk \
    "$IPK_DIR"/luci-base*.ipk \
    "$IPK_DIR"/luci-compat*.ipk \
    "$IPK_DIR"/dns2socks*.ipk \
    "$IPK_DIR"/microsocks*.ipk \
    "$IPK_DIR"/ipt2socks*.ipk \
    "$IPK_DIR"/chinadns-ng*.ipk \
    "$IPK_DIR"/tcping*.ipk \
    "$IPK_DIR"/geoview*.ipk
  do
    [ -f "$pkg" ] && opkg install "$pkg" || true
  done

  # 再装核心
  for pkg in \
    "$IPK_DIR"/xray-core*.ipk \
    "$IPK_DIR"/sing-box*.ipk \
    "$IPK_DIR"/hysteria*.ipk \
    "$IPK_DIR"/tuic-client*.ipk \
    "$IPK_DIR"/trojan-plus*.ipk \
    "$IPK_DIR"/shadow-tls*.ipk \
    "$IPK_DIR"/v2ray-plugin*.ipk \
    "$IPK_DIR"/xray-plugin*.ipk \
    "$IPK_DIR"/naiveproxy*.ipk \
    "$IPK_DIR"/haproxy*.ipk \
    "$IPK_DIR"/simple-obfs*.ipk \
    "$IPK_DIR"/shadowsocks-libev*.ipk \
    "$IPK_DIR"/shadowsocks-rust*.ipk \
    "$IPK_DIR"/shadowsocksr-libev*.ipk
  do
    [ -f "$pkg" ] && opkg install "$pkg" || true
  done

  # 最后装 PassWall 主程序
  for pkg in "$IPK_DIR"/luci-app-passwall*.ipk; do
    [ -f "$pkg" ] && opkg install "$pkg" || true
  done
fi

echo "==> 安装完成"
echo "==> 建议执行："
echo "    /etc/init.d/uhttpd restart"
echo "==> 然后刷新 LuCI 页面查看 PassWall"
