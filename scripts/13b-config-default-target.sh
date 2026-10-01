#!/bin/bash
set -e

IS_DESKTOP="${IS_DESKTOP:-false}"

log() { echo "[$(date +'%Y-%m-%d %H:%M:%S')] [13b] $*"; }

if [ "$IS_DESKTOP" = "false" ]; then
    log "  └─ 非桌面构建, 跳过 (保持 multi-user.target)"
    exit 0
fi

log "🖥️ 配置默认启动目标 (graphical.target)"

# 显式写入 default.target -> graphical.target。
# 缺省会回退到 multi-user.target, 导致装好桌面也进不了图形界面。
mkdir -p rootdir/etc/systemd/system
ln -sfn /lib/systemd/system/graphical.target rootdir/etc/systemd/system/default.target

# 幂等: display-manager.service 是 gdm3 提供的别名
chroot rootdir systemctl enable display-manager.service || true

log "✅ 默认启动目标配置完成"
