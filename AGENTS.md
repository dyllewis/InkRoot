# AGENTS.md

InkRoot（墨迹·墨笔记·墨计划）是一款本地优先的跨平台笔记应用（Flutter），支持连接官方服务器或自托管 Memos 服务同步，提供 WebDAV 备份、Markdown、多级标签、知识图谱、AI 辅助等能力。当前仓库是 `dyllewis/InkRoot`（fork 自 yyyyymmmmm/InkRoot，原作者已停更），远程 `origin` 指向本 fork。

## 常用命令

```bash
flutter pub get          # 安装依赖
flutter analyze          # 静态分析（发布前必须零 error）
flutter test             # 单元测试
flutter gen-l10n         # 生成国际化代码（pubspec 已设 generate: true，build 时自动）
dart tool/inkroot.dart <command>   # 维护 CLI：analyze / test / verify / store-check / build / run / release / clean / ci
scripts/ci.sh [mode]     # 平台构建入口（android-release / ios-sim / macos-release / windows-release / linux-release 等）
flutter run -d <device>  # 本地运行
flutter build apk        # Android；aab 用于上架
```

发布产物走 GitHub Actions（`.github/workflows/ci.yml`、`release.yml`），桌面端打包脚本在 `scripts/`（dmg、无签名 ipa 等）。

## 目录结构

- `lib/config/` — 应用配置与身份（app_config、app_identity）
- `lib/models/` / `lib/providers/` — 数据模型与状态（Provider 状态管理）
- `lib/routes/` — go_router 路由
- `lib/screens/` — 页面级 UI
- `lib/services/` — 业务服务（同步、AI、WebDAV、导入导出等）
- `lib/l10n/` — 国际化 arb 源文件（模板为 `app_zh.arb`）
- `docs/` — 架构文档、ADR、维护手册、官网源码（docs/site）
- `tool/inkroot.dart` — 维护 CLI；`scripts/` — 平台构建脚本
- 平台目录：android / ios / linux / macos / web / windows 全部支持

## 重要约定与注意事项

- **版本号**：`pubspec.yaml` 的 `version: 1.1.13+10113` 是唯一真相源，发版时需同步更新 `CHANGELOG.md`、`CHANGELOG.en.md`、`README.md`/`README.en.md` 中的版本描述（参考 `docs/MAINTENANCE.md`）。
- **国际化**：改 UI 文案要同时更新 `app_zh.arb` 和 `app_en.arb`；生成的 `app_localizations*.dart` 已提交入库，`flutter gen-l10n` 后记得提交。
- **代码规范**：`analysis_options.yaml` 开启了 `implicit-casts: false` 和 `implicit-dynamic: false`，`missing_required_param`/`missing_return` 为 error 级别；另有更严格的 `analysis_options_strict.yaml`。
- **敏感信息**：`tool/inkroot.dart` 内含硬编码的云端校验 AppId/AppKey 和 Android 证书指纹，不要将新的密钥提交入库。
- **同步兼容**：Memos 兼容层需覆盖 0.21–0.29（自部署场景），改动同步逻辑前先读 `docs/architecture/` 和 `docs/development/troubleshooting.md`。
- **构建产物**：`build/` 目录绝不能提交（历史上曾因提交 Flutter Web 编译产物导致仓库膨胀）。
- 文档、提交信息、用户可见文案以中文为主，面向用户的双语文案需中英同步。
