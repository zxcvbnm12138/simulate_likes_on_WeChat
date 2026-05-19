# simulate_likes_on_WeChat

HarmonyOS / ArkTS 微信界面与朋友圈点赞模拟项目，包含聊天、通讯录、发现、个人页、朋友圈列表、朋友圈详情、点赞评论等页面，并集成了部分 AGC 认证与云存储测试代码。

## 功能概览

- 模拟微信底部导航、聊天列表、通讯录、发现和个人页。
- 朋友圈列表、朋友圈详情和个人朋友圈页面。
- 朋友圈点赞、取消点赞、评论展示、头像和昵称数据模拟。
- 个人资料编辑和微信号展示。
- `test2.ets` 中包含 AGC 登录、文件上传、云数据库查询等测试逻辑。

## 技术栈

- HarmonyOS ArkTS
- DevEco Studio / Hvigor
- AGC 认证、云存储、云数据库相关测试代码

## 目录结构

```text
simulate_likes_on_WeChat/
├─ AppScope/               # 应用级配置
├─ entry/                  # 主模块源码与资源
│  └─ src/main/ets/
│     ├─ components/       # 页面组件
│     ├─ pages/            # 页面入口
│     └─ utils/            # 模拟数据和工具函数
├─ hvigor/                 # 构建工具配置
├─ oh-package.json5        # OpenHarmony 包配置
└─ ARCHIVE.md              # 项目归档记录
```

## 本地运行

建议使用 DevEco Studio 打开项目，完成依赖同步后运行 `entry` 模块。命令行构建可使用项目当前 Hvigor 配置执行，具体命令以本机 DevEco/Hvigor 环境为准。

## 归档状态

本项目已在 2026-05-19 做清理硬盘前归档，归档记录见 [ARCHIVE.md](./ARCHIVE.md)。

远程仓库：

```text
https://github.com/zxcvbnm12138/wx_like.git
```

当前归档分支：`master`
