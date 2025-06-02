# V2bX

A V2board node server based on Xray-Core.

一个基于Xray的V2board节点服务端，支持V2ay,Trojan,Shadowsocks协议

Find the source code here: [InazumaV/V2bX](https://github.com/InazumaV/V2bX)

如对脚本不放心，可使用此少验证一遍再使用: [https://killercoda.com/playgrounds/scenario/ubuntu](https://killercoda.com/playgrounds/scenario/ubuntu)

## 详细使用教程

### 安装

\`\`\`bash
bash <(curl -Ls https://raw.githubusercontent.com/RAY1234555555/V2bX-script/master/install.sh)
\`\`\`

### 更新

\`\`\`bash
bash <(curl -Ls https://raw.githubusercontent.com/RAY1234555555/V2bX-script/master/install.sh)
\`\`\`

### 卸载

\`\`\`bash
bash <(curl -Ls https://raw.githubusercontent.com/RAY1234555555/V2bX-script/master/install.sh) uninstall
\`\`\`

## 配置文件说明

配置文件位于 `/usr/local/V2bX/config.json`，安装过程中会引导你输入以下信息：

- `APIHost`: V2board 面板地址
- `NodeID`: 节点 ID
- `Key`: 通信密钥

如需重新配置，可以运行：

\`\`\`bash
/usr/local/V2bX/initconfig.sh
\`\`\`

## 服务管理

\`\`\`bash
# 启动服务
systemctl start V2bX

# 停止服务
systemctl stop V2bX

# 重启服务
systemctl restart V2bX

# 查看服务状态
systemctl status V2bX

# 查看服务日志
journalctl -u V2bX -f
\`\`\`

## 常见问题

1. 服务启动失败，请检查配置文件是否正确
2. 无法连接面板，请检查 APIHost、NodeID 和 Key 是否正确
3. 节点显示离线，请检查防火墙是否放行对应端口

如有其他问题，请提交 Issue。
\`\`\`

这个修正后的 README.md 有以下改进：

1. 修复了安装命令的格式，确保没有多余的 `bash` 单词
2. 使用了正确的代码块格式，避免格式混乱
3. 添加了重新配置的命令说明
4. 保持了原有的内容结构和信息

请将这个修正后的 README.md 文件上传到你的 GitHub 仓库，替换原来的文件。

