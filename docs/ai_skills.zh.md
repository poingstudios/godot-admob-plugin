# 代理技能 (Beta)

代理技能是可移植、自包含的指令集，可帮助 AI 编码助手（例如 Antigravity、Claude Code 和 Cursor）更准确地理解 Godot AdMob 编辑器插件的 API、约定和模式。

代理技能不会用每个平台的信息在 AI 的系统提示词中造成负担，而是利用渐进式披露。这使 AI 助手只需加载执行您的特定任务所需的指令和资源。

---

## 安装技能

您可以使用编辑器将预构建的 AdMob 代理技能直接安装到您的 Godot 项目中：

1. 打开您的 Godot 项目。
2. 在编辑器顶部菜单中，单击 **Project > Tools > AdMob Manager**。
3. 选择 **AI Copilot** 标签页。
4. 单击 **Install AI Skills to Project**。

这将在您的项目根目录下自动创建一个 `.skills/` 文件夹，并将可用的技能放置在其中。

!!! note
    以点开头的文件或文件夹（如 `.skills`）默认在 Godot 的 FileSystem 面板中处于隐藏状态，但对于外部 IDE 和 AI 编码助手是完全可见的。

### 更新技能
为确保您的 AI 助手能够访问最新的功能和最佳实践，请保持您的技能处于最新状态。要更新，请在 Godot 编辑器中打开 AdMob 管理器并再次单击 **Install AI Skills to Project**，以使用最新文件覆盖该文件夹。

---

## 调用技能
一旦技能安装到您的项目仓库中，您的 AI 助手将自动索引和检测它们。您不需要在提示词中显式使用 `@` 符号；当您询问有关 AdMob 的问题时，助手会自动引用技能上下文。

如果您想手动强制助手使用特定技能，可以通过输入 `@` 后跟技能名称来引用，例如：
`@godot-admob-banner`

---

## 查看可用技能

下表描述了 Godot AdMob 编辑器插件功能的所有可用技能：

| 技能 | 描述 |
| :--- | :--- |
| `godot-admob-get-started` | 协助初始化 Google Mobile Ads SDK、设置请求配置以及配置用户消息平台 (UMP) 同意流程。 |
| `godot-admob-banner` | 协助实现横幅广告（`AdView`）、选择广告尺寸以及设置可折叠横幅广告。 |
| `godot-admob-interstitial` | 协助实现全屏插屏广告、加载广告以及设置关闭回调。 |
| `godot-admob-rewarded` | 协助实现激励广告和激励插屏广告、监听用户获得奖励事件以及清理广告引用。 |
| `godot-admob-app-open` | 协助实现在应用启动或应用过渡期间展示的 App Open 广告。 |
| `godot-admob-native-overlay` | 协助使用自定义的小型或中型 Control 节点模板实现 Native Overlay 广告。 |
| `godot-admob-migrate` | 协助在不同的插件版本之间迁移您的项目（例如，从 v4.x 迁移到 v5.x）。 |
| `godot-admob-mediation` | 协助配置、集成和验证第三方中介网络（AppLovin、Meta Audience Network、Unity Ads 等）。 |
| `godot-admob-troubleshoot` | 协助诊断广告加载错误、处理错误代码、打开广告检查器以及解决集成问题。 |
| `godot-admob-privacy` | 协助配置用户同意（UMP 流程）、GDPR 合规、COPPA（面向儿童的处理）、CCPA 以及请求定向选项。 |

您可以通过向您喜欢的 AI 助手发送提示来实现 Godot AdMob 编辑器插件的代理技能。代理技能可以指导您的 AI 助手执行以下示例任务：

* *帮我初始化 Godot AdMob 编辑器插件。*
* *在我的游戏中添加横幅广告。*
* *实现一个激励广告。*
* *将我的项目从 v4 迁移到 v5。*
* *配置 GDPR 和 COPPA 隐私合规。*
* *排查我的广告为何无法加载。*
