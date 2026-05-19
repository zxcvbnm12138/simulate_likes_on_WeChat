# 项目归档记录

## 2026-05-19 清理硬盘前归档

本次归档用于在删除本地 `D:\GC\simulate_likes_on_WeChat` 前保留可恢复的远程版本。

### 归档范围

- HarmonyOS / ArkTS 微信界面模拟项目源码。
- 聊天、通讯录、发现、我的、朋友圈列表、朋友圈详情和个人朋友圈页面。
- 点赞、取消点赞、评论、朋友圈数据展示等模拟逻辑。
- AGC 认证、文件上传、云数据库查询等测试页逻辑。
- 当前本地已有的页面、资源、schema 和配置变更。

### 远程信息

- 远程仓库：`https://github.com/zxcvbnm12138/simulate_likes_on_WeChat.git`
- 归档分支：`master`
- 归档日期：`2026-05-19`

### 恢复方式

```bash
git clone https://github.com/zxcvbnm12138/simulate_likes_on_WeChat.git
cd simulate_likes_on_WeChat
```

恢复后建议使用 DevEco Studio 打开项目并重新同步依赖。
