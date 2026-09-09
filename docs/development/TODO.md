# 遗留问题清单（按优先级待修）

> 来源：2026-09 会话过期修复（`b163bfe`）及子代理复审（返工见 `e41b905`）中
> 暂缓的项目。修复后请删除对应条目；条目中的行号会随代码漂移，以符号名为准。
>
> 背景速览：Memos 会话约 7 天过期，客户端靠「静默重登」（保存的账号密码自动
> 重新登录，带 5 分钟冷却 + in-flight 去重）续期。本次已让首页下拉刷新、
> 账户页、备份恢复、修改资料等全部用户可见路径接入该机制。

## P1-2 会话不可恢复时，UI 仍显示原始异常文案

- **现象**：仅剩两种边界会弹原始错误——① 凭据被服务器明确拒绝（已强制登出）；
  ② 静默重登处于 5 分钟冷却期或服务器暂时不可用。此时首页弹
  「刷新失败: TokenExpiredException: Token无效或已过期…」，账户页/备份恢复页类似。
  常见场景（凭据有效、可自动恢复）已全部修复，不影响日常使用。
- **建议修法**：引入语义化异常（如 `SessionExpiredException` /
  `ServerTemporarilyUnavailableException`），在 UI 层 catch 中映射为友好文案；
  文案需中英同步（`app_zh.arb` + `app_en.arb` + `flutter gen-l10n`）。
- **涉及**：
  - `lib/providers/app_provider.dart`：`refreshFromServerFast`、`fetchUserInfoWithRecovery`
  - `lib/providers/app_provider_sync.part.dart`：`syncWithServer`
  - `lib/screens/home_screen.dart` `_refreshNotes` 的 catch（~500 行）
  - `lib/screens/account_info_screen.dart` `_syncUserInfo` 的 catch（~132 行）
  - `lib/screens/local_backup_restore_screen.dart`（~1800 行）
- **注意**：不能把异常静默吞掉——首页/备份恢复页依赖异常区分成败，
  吞掉会误报「同步成功」（见 `e41b905` 中注释）。

## P2-2 四处近似的 Token 过期处理代码待收敛

- **现状**：`refreshFromServerFast`、`syncWithServer`、`runWithAuthRecovery`、
  `fetchUserInfoWithRecovery` 四处的「过期 → 静默重登 → 重试/登出/等待」逻辑
  高度相似，且 credentialFailure 策略不一致（`runWithAuthRecovery` 不调
  `_handleTokenExpired`，依赖下次同步兜底）。
- **建议**：抽公共的恢复方法（返回枚举），各调用方按语义决定 rethrow/return。
  与 P1-2 的语义化异常一起做最划算。

## P2-6 静默重登去重逻辑零测试

- **现状**：`trySilentRelogin` 的 in-flight 去重（`_silentReloginInFlight`）是
  本次修复的核心、也是最易回归之处，但无任何测试。`AppProvider` 直接实例化
  `DatabaseService`/`PreferencesService`，无法注入 mock。
- **建议**：先做构造函数注入改造（或引入 mocktail/mockito），再补并发去重
  单测：两个并发调用共享同一次重登请求；完成后冷却生效；冷却期内返回
  retryLater 不发请求。

## P2-3 同步消息硬编码中文未走 l10n

- **现状**：「已自动恢复登录状态」「登录已过期，请重新登录」「暂时无法连接
  服务器，稍后将自动重试登录」等 syncMessage 全部硬编码中文（与该文件既有
  模式一致）。目前无屏幕组件直接渲染这些消息（仅进入桌面小组件快照），
  但若快照对外展示，英文用户会看到中文。
- **建议**：严格按 AGENTS.md 双语要求时，补 arb 词条并统一改走 l10n。

## P2-4 行为收紧（已生效，留意用户反馈即可）

- 无保存账号密码（未勾选「记住登录」）的用户，会话过期后此前仅报错、保留
  登录态；现在 `refreshFromServerFast`/`syncWithServer`/`fetchUserInfoWithRecovery`
  遇到会话过期会走 `_handleTokenExpired` 直接强制登出。
- 符合「凭据无法自动恢复就该重新登录」的产品意图，但属语义变更，发版后
  留意相关反馈。

## P2-5 多条同步链路间无互斥（既有问题）

- `_isSyncing`/`_syncMessage` 会被并发同步流程交叉覆盖（如下拉刷新与后台
  `fetchNotesFromServer` 并发时提示互相顶掉）。数据层有 `_syncingNoteIds`
  + upsert 幂等兜底，无损坏风险，仅状态展示问题。
- **建议**：引入同步互斥（SingleFlight 或串行队列），或把瞬时提示与持久
  状态分离。

## 可选增强：前后台切换时主动校验会话

- 现状：应用从后台恢复后若会话已过期，首个用户操作会经历一次静默重登
  （已无感，仅首次操作略慢一次请求）。全仓库无 `WidgetsBindingObserver`。
- 可选：在 resume 时触发一次 `refreshFromServerFast()`（自带恢复逻辑）
  提前续期。曾评估过「定时器空闲周期拉取保活」方案，因移动端功耗/流量
  回归已在 `e41b905` 回退，勿轻易恢复。
