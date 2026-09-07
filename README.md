# InkRoot

InkRoot 是一款面向个人知识记录的跨平台笔记应用。它可以本地优先使用，也可以连接自托管的 Memos 服务进行同步。应用提供 Memos 兼容 Markdown、图片、标签、提醒、搜索、WebDAV 备份、导入导出、系统分享、小组件和可选 AI 辅助等能力。

[下载最新版本](https://github.com/yyyyymmmmm/InkRoot/releases/latest) · [问题反馈](https://github.com/yyyyymmmmm/InkRoot/issues) · [English](README.en.md)

## 当前版本

`1.1.14`

本版本修复连接自建 Memos 服务端一段时间后自动退出登录的问题：登录改为申请永不过期的会话，Token 失效时会尝试用已保存的账号密码静默重登，网络故障不再清除本地凭据。同时应用完全自托管化，移除对原官方服务器的依赖（云验证、云公告、云端更新检查均已下线），登录/注册页改为直接填写自建服务器地址。

主要变化：

- 登录自建 Memos 服务端时申请永不过期的会话，修复一段时间后被自动退出登录的问题。
- Token 失效时优先用已保存的账号密码静默重登，登录状态更稳定。
- 服务器暂时离线等网络故障不再清除本地登录凭据，恢复网络后可继续同步。
- 登录、注册页移除「官方服务器」选项，直接填写自建 Memos 服务器地址并记住上次输入。
- 移除云验证、云公告和云端更新检查，应用不再连接原官方服务器。
- 通知中心专注提醒通知，账号删除页与法律文档同步改为自托管表述。
- 设置中新增账号与数据删除入口，并提供公开删除申请页面。
- iOS 隐私清单、权限声明和法律文档已按当前数据流更新。
- 官网已更新产品首页、下载页、使用指南、FAQ、完整更新日志和法律页面。
- 维护 CLI 覆盖检查、构建和发布入口。
- GitHub Actions 覆盖 Android、iOS、macOS、Windows 和 Linux。

## 功能

- 本地笔记和自部署 Memos 服务器同步。
- Markdown 渲染、待办事项、链接、图片和标签。
- 多层级标签，例如 `#工作/项目A`。
- 全文搜索、置顶、提醒和随机回顾。
- 图片上传、预览、保存和多图浏览。
- WebDAV 备份和恢复，可选择是否备份图片附件。
- Flomo、微信读书等数据导入。
- Android 和 iOS 系统分享入口。
- 快速记录和随机回顾桌面小组件。
- AI 辅助写作和自定义提示词。
- 中文和英文界面。
- Android、iOS、macOS、Windows 和 Linux 构建。

## 下载

发布包在 [GitHub Releases](https://github.com/yyyyymmmmm/InkRoot/releases) 页面提供。

GitHub Releases 的 Android APK 用于手动安装和测试分发；Google Play 上架使用发布流程生成的签名 AAB。
Windows 用户下载压缩包后运行应用。
Linux 用户下载压缩包后解压运行。
iOS 和 macOS 包当前用于测试分发。

## 开发

安装 Flutter 后运行：

```bash
flutter pub get
dart tool/inkroot.dart verify
```

常用命令：

```bash
dart tool/inkroot.dart doctor
dart tool/inkroot.dart analyze
dart tool/inkroot.dart test
dart tool/inkroot.dart store-check
dart tool/inkroot.dart build android-debug
dart tool/inkroot.dart build ios-sim
dart tool/inkroot.dart build macos-debug
dart tool/inkroot.dart build windows-debug
dart tool/inkroot.dart build linux-debug
```

不同桌面或移动平台需要对应系统环境。例如 iOS 和 macOS 需要 macOS 与 Xcode，Windows 需要 Windows 与 Visual Studio C++ 桌面组件，Linux 需要 GTK、CMake 和 Ninja。

## 发布

版本号统一维护在 `pubspec.yaml`：

```yaml
version: 1.1.14+10114
```

发布入口：

```bash
dart tool/inkroot.dart release v1.1.14
```

这个命令会创建并推送版本 tag。GitHub Actions 收到 tag 后自动执行检查、构建并发布 Android APK/AAB、iOS、macOS、Windows 和 Linux 产物。

## 文档

- [项目结构与构建指南](docs/PROJECT_STRUCTURE_AND_BUILD.md)
- [维护指南](docs/MAINTENANCE.md)
- [商店合规清单](docs/STORE_COMPLIANCE.md)
- [更新日志](CHANGELOG.md)
- [安全政策](SECURITY.md)
- [贡献指南](CONTRIBUTING.md)

## 法律与隐私

- [隐私政策](https://inkroot.cn/privacy.html)
- [用户协议](https://inkroot.cn/agreement.html)
- [账号与数据删除](https://inkroot.cn/account-deletion.html)

## 许可证

InkRoot 使用 MIT License。详见 [LICENSE](LICENSE)。
