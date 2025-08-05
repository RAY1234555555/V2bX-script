#!/bin/bash
CONFIG_FILE="/etc/V2bX/config.json"
SERVICE_NAME="V2bX"

echo "🔧 修复 V2bX 配置开始..."

# 备份原配置
cp "$CONFIG_FILE" "${CONFIG_FILE}.bak.$(date +%F_%T)"
echo "备份完成: ${CONFIG_FILE}.bak.$(date +%F_%T)"

# 读取配置，判断是否包含 Nodes 字段
if jq -e '.Nodes' "$CONFIG_FILE" >/dev/null 2>&1; then
  echo "检测到 Nodes 字段，尝试修正 Type 字段..."

  # 修正 NodeType->Type，Type为空补"vmess"
  jq '(.Nodes[] |= (if has("NodeType") then .Type = .NodeType | del(.NodeType) else . end) | map(if .Type == null or .Type == "" then .Type = "vmess" else . end))' "$CONFIG_FILE" | sponge "$CONFIG_FILE"

else
  echo "未检测到 Nodes 字段，尝试包装单节点为 Nodes 数组，并修正 Type 字段..."

  # 读取原配置，转换为 Nodes 数组结构，并修正 NodeType/Type 问题
  jq -c '{
    Nodes: [
      if has("NodeType") then . + {Type: .NodeType} | del(.NodeType) else . end
    ]
  }' "$CONFIG_FILE" | \
  jq '(.Nodes[] |= (if .Type == null or .Type == "" then .Type = "vmess" else . end))' | sponge "$CONFIG_FILE"

fi

echo "配置修正完成，尝试重启服务 $SERVICE_NAME ..."

systemctl restart "$SERVICE_NAME"

if systemctl is-active --quiet "$SERVICE_NAME"; then
  echo "✅ $SERVICE_NAME 服务重启成功"
else
  echo "❌ $SERVICE_NAME 服务重启失败，请检查日志"
fi
