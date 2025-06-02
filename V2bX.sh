#!/bin/bash

# 检测是否为Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

# 工作目录
DIR="/usr/local/V2bX"
mkdir -p ${DIR}

# 检查系统架构
ARCH=$(uname -m)
case $ARCH in
    x86_64) ARCH="amd64" ;;
    aarch64) ARCH="arm64" ;;
    *) echo "不支持的系统架构: $ARCH"; exit 1 ;;
esac

# 检查操作系统
OS=$(uname -s)
case $OS in
    Linux) OS="linux" ;;
    *) echo "不支持的操作系统: $OS"; exit 1 ;;
esac

# 获取最新版本
echo "正在获取最新版本..."
VERSION=$(curl -s https://api.github.com/repos/InazumaV/V2bX/releases/latest | grep "tag_name" | cut -d\" -f4)
if [ -z "$VERSION" ]; then
    echo "获取版本信息失败，可能是 GitHub API 限制，请稍后再试"
    # 使用备用方式获取版本
    VERSION=$(curl -s https://raw.githubusercontent.com/RAY1234555555/V2bX-script/master/version.txt)
    if [ -z "$VERSION" ]; then
        echo "备用方式获取版本也失败，使用默认版本"
        VERSION="v1.0.0"
    fi
fi

echo "最新版本为: $VERSION"

# 下载地址
DOWNLOAD_URL="https://github.com/InazumaV/V2bX/releases/download/$VERSION/V2bX-$OS-$ARCH.tar.gz"
echo "下载地址: $DOWNLOAD_URL"

# 下载文件
echo "开始下载文件..."
wget -O V2bX.tar.gz $DOWNLOAD_URL
if [ $? -ne 0 ]; then
    echo "下载失败，请检查网络或稍后再试"
    exit 1
fi

# 解压文件
echo "解压文件..."
tar -xzf V2bX.tar.gz -C ${DIR}
rm -f V2bX.tar.gz

# 设置权限
chmod +x ${DIR}/V2bX

# 检查是否已安装
if [ -f "${DIR}/config.json" ]; then
    echo "检测到已存在配置文件，跳过初始化配置"
else
    echo "未检测到配置文件，开始初始化配置..."
    cd ${DIR}
    ./initconfig.sh
fi

# 安装服务
if [ ! -f "/etc/systemd/system/V2bX.service" ]; then
    echo "安装服务..."
    wget -N --no-check-certificate https://raw.githubusercontent.com/RAY1234555555/V2bX-script/master/V2bX.service -O /etc/systemd/system/V2bX.service
    systemctl daemon-reload
    systemctl enable V2bX
fi

# 启动服务
echo "启动服务..."
systemctl restart V2bX

# 检查服务状态
echo "检查服务状态..."
systemctl status V2bX

echo "安装完成！"
echo "配置文件路径: ${DIR}/config.json"
echo "日志文件路径: ${DIR}/V2bX.log"
echo "使用以下命令管理服务:"
echo "启动: systemctl start V2bX"
echo "停止: systemctl stop V2bX"
echo "重启: systemctl restart V2bX"
echo "状态: systemctl status V2bX"
echo "卸载: bash <(curl -Ls https://raw.githubusercontent.com/RAY1234555555/V2bX-script/master/install.sh) uninstall"