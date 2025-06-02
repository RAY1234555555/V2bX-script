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
    echo "未检测到系统版本，请联系脚本作者！\n" && exit 1
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

# 传参
if [ "$1" = "uninstall" ]; then
    echo "正在执行卸载程序..."
    systemctl stop V2bX
    systemctl disable V2bX
    rm -rf /etc/systemd/system/V2bX.service
    rm -rf /usr/local/V2bX/
    echo "卸载完成"
    exit 0
fi

# 安装依赖
if [[ ${release} == "centos" ]]; then
    yum install wget curl tar -y
else
    apt-get update
    apt-get install wget curl tar -y
fi

# 下载安装包
echo "开始下载安装包..."
wget -N --no-check-certificate https://raw.githubusercontent.com/RAY1234555555/V2bX-script/master/V2bX.sh
chmod +x V2bX.sh

# 下载服务文件
echo "开始下载服务文件..."
wget -N --no-check-certificate https://raw.githubusercontent.com/RAY1234555555/V2bX-script/master/V2bX.service
chmod +x V2bX.service
mv V2bX.service /etc/systemd/system/

# 下载配置文件
echo "开始下载配置文件..."
wget -N --no-check-certificate https://raw.githubusercontent.com/RAY1234555555/V2bX-script/master/initconfig.sh
chmod +x initconfig.sh

# 创建目录
mkdir -p /usr/local/V2bX
mv V2bX.sh /usr/local/V2bX/
mv initconfig.sh /usr/local/V2bX/

# 初始化配置
echo "开始初始化配置..."
cd /usr/local/V2bX/
./initconfig.sh

# 启动服务
echo "启动服务..."
systemctl daemon-reload
systemctl enable V2bX
systemctl start V2bX

# 检测服务状态
echo "检测服务状态..."
systemctl status V2bX

echo "安装完成，请修改配置文件后重启服务"
echo "配置文件路径: /usr/local/V2bX/config.json"
echo "重启命令: systemctl restart V2bX"