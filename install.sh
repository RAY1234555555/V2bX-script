#!/bin/bash

# 检测是否为Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

# 检测系统类型
if [[ -f /etc/redhat-release ]]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
else
    echo "未检测到系统版本，请联系脚本作者！" && exit 1
fi

# 检测系统版本
if [[ -s /etc/redhat-release ]]; then
    version=`grep -oE  "[0-9.]+" /etc/redhat-release | cut -d . -f 1`
else
    version=`grep -oE  "[0-9.]+" /etc/issue | cut -d . -f 1`
fi

bit=`uname -m`
if [[ ${bit} = "x86_64" ]]; then
    bit="x64"
else
    bit="x32"
fi

echo "检测到您的系统为: ${release} ${version} ${bit}"

# 传参处理
if [ "$1" = "uninstall" ]; then
    echo "正在执行卸载程序..."
    systemctl stop V2bX
    systemctl disable V2bX
    rm -rf /etc/systemd/system/V2bX.service
    rm -rf /usr/local/V2bX/
    systemctl daemon-reload
    echo "卸载完成"
    exit 0
fi

# 安装依赖
echo "正在安装依赖..."
if [[ ${release} == "centos" ]]; then
    yum install wget curl tar -y
else
    apt-get update
    apt-get install wget curl tar -y
fi

# 创建工作目录
mkdir -p /usr/local/V2bX
cd /usr/local/V2bX

# 下载脚本文件
echo "正在下载脚本文件..."
wget -N --no-check-certificate https://raw.githubusercontent.com/RAY1234555555/V2bX-script/master/V2bX.sh
chmod +x V2bX.sh

# 下载服务文件
echo "正在下载服务文件..."
wget -N --no-check-certificate https://raw.githubusercontent.com/RAY1234555555/V2bX-script/master/V2bX.service
mv V2bX.service /etc/systemd/system/

# 下载配置脚本
echo "正在下载配置脚本..."
wget -N --no-check-certificate https://raw.githubusercontent.com/RAY1234555555/V2bX-script/master/initconfig.sh
chmod +x initconfig.sh

# 运行主安装脚本
echo "正在安装 V2bX..."
./V2bX.sh

# 如果配置文件不存在，运行配置脚本
if [ ! -f "/usr/local/V2bX/config.json" ]; then
    echo "开始配置 V2bX..."
    ./initconfig.sh
fi

# 启动服务
echo "正在启动服务..."
systemctl daemon-reload
systemctl enable V2bX
systemctl start V2bX

# 检查服务状态
echo "检查服务状态..."
sleep 3
systemctl status V2bX

echo ""
echo "安装完成！"
echo "配置文件路径: /usr/local/V2bX/config.json"
echo "日志文件路径: /usr/local/V2bX/V2bX.log"
echo ""
echo "常用命令："
echo "启动服务: systemctl start V2bX"
echo "停止服务: systemctl stop V2bX"
echo "重启服务: systemctl restart V2bX"
echo "查看状态: systemctl status V2bX"
echo "查看日志: tail -f /usr/local/V2bX/V2bX.log"
echo ""
echo "如需重新配置，请运行: /usr/local/V2bX/initconfig.sh"
