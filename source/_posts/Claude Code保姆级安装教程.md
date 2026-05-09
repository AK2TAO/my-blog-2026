---
title: Claude Code保姆级安装教程
date: 2026-05-09
updated: 2026-05-09
categories: [AI]
tags: [Claude Code, 教程, 工具]
poster:
  headline: Claude Code保姆级安装教程
comments: true
---

## 1.安装Git bash
Claude Code 原生是给 Linux /macOS 写的，它依赖 Linux 风格的命令和终端环境，而 Windows 本身没有这些。

Git for Windows 自带了一套完整的 Linux 命令工具（bash、ls、cat、chmod 等），刚好能让 Claude Code 正常运行。

git官网下载地址：[Git - Install for Windows](https://git-scm.com/install/windows)

## 2.安装Claude Code 本体
打开终端（Windows 用 PowerShell，Mac/Linux 用 Terminal），粘贴命令即可：`irm https://claude.ai/install.ps1 | iex`

## 3.配置环境变量PATH
把 `C:\Users\你的用户名\.local\bin\` 加到用户级 PATH

![配置环境变量](https://abstrac1on-1316638019.cos.ap-guangzhou.myqcloud.com/Claude_dir/claude%E7%8E%AF%E5%A2%83%E5%8F%98%E9%87%8F.png)

## 4.安装 cc-switch，接入更多模型
**cc-switch**，它可以切换不同的 AI 模型提供商。
官网地址：`https://ccswitch.lovable.app`

进入软件配置AI模型提供商，我这里以DeepSeek V4 Pro为例：
### 1. 先登录Deepseek官网请求API接口
+ DeepSeek官网地址：[DeepSeek | 深度求索](https://www.deepseek.com/)
+ ![进入官网](https://abstrac1on-1316638019.cos.ap-guangzhou.myqcloud.com/Claude_dir/deepseekapi%E5%9C%B0%E5%9D%80.png)
+ ![申请api](https://abstrac1on-1316638019.cos.ap-guangzhou.myqcloud.com/Claude_dir/%E7%94%B3%E8%AF%B7api%E6%8E%A5%E5%8F%A3.png)
+ 注意：deepseek的api接口是需要付费的
+ api_key密钥生成只会生成一次，如果忘记了就只能重新再创建一个

### 2. 拿到api_key后进入cc-switch软件
+ 添加AI模型
![添加AI模型](https://abstrac1on-1316638019.cos.ap-guangzhou.myqcloud.com/Claude_dir/ccswitch%E9%85%8D%E7%BD%AE1.png)
![添加AI模型](https://abstrac1on-1316638019.cos.ap-guangzhou.myqcloud.com/Claude_dir/ccswitch%E9%85%8D%E7%BD%AE2.png)
+ 详细配置
![添加AI模型](https://abstrac1on-1316638019.cos.ap-guangzhou.myqcloud.com/Claude_dir/ccswitch%E9%85%8D%E7%BD%AE3.png)
![输入apikey](https://abstrac1on-1316638019.cos.ap-guangzhou.myqcloud.com/Claude_dir/ccswitch%E9%85%8D%E7%BD%AE4.png)
+ 也可以把pro改成flash版本，两者其实用起来区别不大，但flash比pro要更加节省token
![配置模型](https://abstrac1on-1316638019.cos.ap-guangzhou.myqcloud.com/Claude_dir/ccswitch%E9%85%8D%E7%BD%AE5.png)
+ 其余的不需要动，保存即可

## 5.使用Claude Code
1. 随便进入一个文件夹，在地址栏输入cmd并回车
![进入文件夹](https://abstrac1on-1316638019.cos.ap-guangzhou.myqcloud.com/Claude_dir/claude%E4%BD%BF%E7%94%A8.png)

2. 命令行内输入claude
![claude使用](https://abstrac1on-1316638019.cos.ap-guangzhou.myqcloud.com/Claude_dir/claude%E4%BD%BF%E7%94%A82.png)
3. 初次运行可能会出现bug
![claude使用](https://abstrac1on-1316638019.cos.ap-guangzhou.myqcloud.com/Claude_dir/claude%E4%BD%BF%E7%94%A83.png)

>**原因：**CC Switch 的作用就是一键修改 Claude Code 的配置文件，但 Claude Code 在首次运行时如果没有通过检测，会直接忽略你自定义的 API 地址，还是会去强行连接官方做登录检查。这时候需要手动修改一个文件。

1. 打开这个文件，比如 `C:\Users\admin\.claude.json`。这个路径里的用户名部分每个人都不一样，看你自己的用户名是什么。
2. 它默认可能是隐藏的，你需要在文件管理器上面勾选一下显示隐藏的文件。如果你的电脑上直接没有这个文件，那就新建一个也可以。
3. 然后把这个内容复制进去：`"hasCompletedOnboarding": true,`
4. 保存文件，确保 CC Switch 已经切换到你自己的渠道后，重启你的 Claude Code。如果你的格式会报错，比如多了一个引号、括号或句号，可以把文件里的内容全选复制，发给任意一个网页版 AI，让它只修复格式、保留原有内容，然后把结果重新粘贴回来。
![bug修改](https://abstrac1on-1316638019.cos.ap-guangzhou.myqcloud.com/Claude_dir/claude%E4%BD%BF%E7%94%A84.png)

## 6.如何卸载Claude Code
1. 以管理员身份打开 PowerShell（普通 PowerShell 也可以），逐行运行：
```powershell
# 删除 claude 可执行文件 
Remove-Item -Path "$env:USERPROFILE\.local\bin\claude.exe" -Force 

# 删除 Claude Code 的版本和共享文件 
Remove-Item -Path "$env:USERPROFILE\.local\share\claude" -Recurse -Force

```

2. 完全清理
```powershell
# 删除主配置文件夹（包含设置、工具、历史记录等）
Remove-Item -Path "$env:USERPROFILE\.claude" -Recurse -Force

# 删除配置文件（如果存在）
Remove-Item -Path "$env:USERPROFILE\.claude.json" -Force
```
>注意
>删除 `~/.claude` 会清除所有 Claude Code 的设置、自定义工具、MCP 服务器和会话历史。以后还想继续使用这些内容，建议先备份这个文件夹。

3. 验证是否卸载干净
```powershell
claude --version
```