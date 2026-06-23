# AI Copilot 技能 (测试版)

使用 **AI Copilot 技能**（AI Copilot Skills），您可以将 AI 驱动的编码助手（例如 Antigravity 中的 Gemini、Cursor、Claude 或 GitHub Copilot）集成到您的游戏开发工作流程中。

AdMob 插件附带了一个预配置的 AI 技能，其中包含了在 **GDScript** 和 **C#** 中集成各种广告格式（横幅广告、插屏广告、激励广告等）的所有规范、API 和代码模式。

---

## 快速安装（内置技能）

只需单击一下，即可将预配置的 AdMob AI 技能直接安装到您的项目中：

1. 打开您的 Godot 项目。
2. 在编辑器顶部菜单中，单击 **Project -> Tools -> AdMob Manager**。
3. 选择 **AI Copilot** 子菜单。
4. 单击 **Install AI Skills to Project**。

这将在您的项目根目录下自动创建一个 `.skills/godot-admob-copilot` 文件夹，并将 `SKILL.md` 指示文件放置其中。

!!! note
    以点开头的文件或文件夹（如 `.skills`）默认在 Godot 的 FileSystem 面板中处于隐藏状态，以避免界面混乱，但对于外部 IDE（如 VS Code、Cursor、Antigravity 等）是完全可见的。

---

## 在提示词中调用技能

将技能添加到项目后，使用以下示例提示词在您的 AI 工具中调用它：

要调用此技能，请输入 `@` 并选择 `godot-admob-copilot` 技能。

=== "初始化 MobileAds"

    ```text
    @godot-admob-copilot 编写完整的初始化流程，包括在 GDScript 中初始化 MobileAds 之前检查 UMP 同意信息。
    ```

=== "添加横幅广告"

    ```text
    @godot-admob-copilot 演示如何在 GDScript 中创建并在屏幕底部显示标准自适应横幅广告。
    ```

=== "添加激励广告"

    ```text
    @godot-admob-copilot 帮我在 C# 中加载激励广告，并实现一个回调，在玩家看完广告后奖励其 100 金币。
    ```


