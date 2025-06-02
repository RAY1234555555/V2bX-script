#!/bin/bash

# 检测是否为Root
[ $(id -u) != "0" ] && { echo "Error: You must be root to run this script"; exit 1; }

# 工作目录
DIR="/usr/local/V2bX"
mkdir -p ${DIR}

# 创建配置文件
cat > ${DIR}/config.json <<EOF
{
  "Log": {
    "Level": "info",
    "Output": "${DIR}/V2bX.log"
  },
  "Api": {
    "APIHost": "http://example.com",
    "NodeID": 1,
    "Key": "123456",
    "NodeType": "V2ray",
    "EnableVless": false,
    "EnableXTLS": false,
    "SpeedLimit": 0,
    "DeviceLimit": 0,
    "RuleListPath": "${DIR}/rulelist",
    "DisableCustomConfig": false
  },
  "Inbound": {
    "Port": 10086,
    "ListenIP": "0.0.0.0",
    "SendIP": "0.0.0.0"
  },
  "Nodes": []
}
EOF

echo "配置文件已生成，请修改 ${DIR}/config.json 中的配置"
echo "特别是 APIHost、NodeID 和 Key 字段，这些是必须修改的"
echo "修改完成后，请重启服务: systemctl restart V2bX"