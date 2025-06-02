#!/bin/bash

# 检测是否为Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

# 工作目录
DIR="/usr/local/V2bX"
mkdir -p ${DIR}

echo "开始配置 V2bX..."
echo "请按照提示输入配置信息"

# 交互式输入配置
read -p "请输入面板地址 (APIHost，如: https://example.com): " api_host
while [[ -z "$api_host" ]]; do
    echo "面板地址不能为空！"
    read -p "请输入面板地址 (APIHost，如: https://example.com): " api_host
done

read -p "请输入节点ID (NodeID): " node_id
while [[ -z "$node_id" || ! "$node_id" =~ ^[0-9]+$ ]]; do
    echo "节点ID必须是数字！"
    read -p "请输入节点ID (NodeID): " node_id
done

read -p "请输入通信密钥 (Key): " api_key
while [[ -z "$api_key" ]]; do
    echo "通信密钥不能为空！"
    read -p "请输入通信密钥 (Key): " api_key
done

read -p "请输入节点类型 (NodeType) [V2ray/Trojan/Shadowsocks，默认: V2ray]: " node_type
node_type=${node_type:-V2ray}

read -p "请输入监听端口 (Port，默认: 10086): " listen_port
listen_port=${listen_port:-10086}

read -p "是否启用 Vless (EnableVless) [true/false，默认: false]: " enable_vless
enable_vless=${enable_vless:-false}

read -p "是否启用 XTLS (EnableXTLS) [true/false，默认: false]: " enable_xtls
enable_xtls=${enable_xtls:-false}

read -p "速度限制 (SpeedLimit，单位 Mbps，0为不限制，默认: 0): " speed_limit
speed_limit=${speed_limit:-0}

read -p "设备数限制 (DeviceLimit，0为不限制，默认: 0): " device_limit
device_limit=${device_limit:-0}

echo "正在生成配置文件..."

# 创建配置文件
cat > ${DIR}/config.json <<EOF
{
  "Log": {
    "Level": "info",
    "Output": "${DIR}/V2bX.log"
  },
  "Api": {
    "APIHost": "${api_host}",
    "NodeID": ${node_id},
    "Key": "${api_key}",
    "NodeType": "${node_type}",
    "EnableVless": ${enable_vless},
    "EnableXTLS": ${enable_xtls},
    "SpeedLimit": ${speed_limit},
    "DeviceLimit": ${device_limit},
    "RuleListPath": "${DIR}/rulelist",
    "DisableCustomConfig": false
  },
  "Inbound": {
    "Port": ${listen_port},
    "ListenIP": "0.0.0.0",
    "SendIP": "0.0.0.0"
  },
  "Nodes": []
}
EOF

echo "配置文件已生成完成！"
echo "配置文件路径: ${DIR}/config.json"
echo ""
echo "配置信息："
echo "面板地址: ${api_host}"
echo "节点ID: ${node_id}"
echo "节点类型: ${node_type}"
echo "监听端口: ${listen_port}"
echo "启用Vless: ${enable_vless}"
echo "启用XTLS: ${enable_xtls}"
echo "速度限制: ${speed_limit} Mbps"
echo "设备限制: ${device_limit}"
echo ""
echo "如需修改配置，请编辑: ${DIR}/config.json"
echo "修改后请重启服务: systemctl restart V2bX"
