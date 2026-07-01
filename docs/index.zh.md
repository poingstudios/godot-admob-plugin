# 入门指南

将AdMob插件集成到您的Godot 3项目中，可以轻松地在Android和iOS设备上展示Google移动广告。

---

## 前提条件

- **Godot Engine 3.x Mono/Standard Edition**（v3.3或更高版本）。
- **Android导出**：
  - 启用Godot Android构建模板。
  - 配置目标Android SDK版本。
- **iOS导出**：
  - 安装了Xcode的macOS机器。
  - 活跃的Apple Developer账户。
- **建议**：拥有已注册Android/iOS应用的活跃[AdMob账户](https://admob.google.com/)。

---

## 下载并导入插件

1. 从[GitHub Releases](https://github.com/poingstudios/godot-admob-plugin/releases)页面下载最新版本。
2. 解压文件并将`addons/admob`文件夹复制到Godot项目的`res://addons/`目录。
3. 打开Godot编辑器，导航到**项目 -> 项目设置 -> 插件**，将**AdMob**插件状态切换为**已启用**。

启用后，插件会自动将`MobileAds`单例注册到您的项目中。

---

## 下载平台模板

在Godot编辑器内打开AdMob管理器（**项目 -> 工具 -> AdMob管理器**或点击**AdMob**面板标签）。

* **Android**：选择**下载Android模板**，将`.aar`和`.gdap`文件获取并解压到`res://android/plugins/`文件夹。
* **iOS**：选择**下载iOS模板**，将`.gdip`和库文件获取并解压到`res://ios/plugins/`文件夹。

---

## 配置

在AdMob编辑器面板中：
1. 设置您的**AdMob应用ID**（例如`ca-app-pub-3940256099942544~1458002511`）。
2. 输入您要使用的格式（横幅、插页、激励、激励插页）的**广告单元ID**。
3. 切换广告是否启用，并配置默认行为如横幅位置和大小。

---

## 初始化SDK

在加载广告之前，必须初始化Google Mobile Ads SDK。如果配置中**已启用**处于活动状态，插件将在启动时自动初始化。

如果您希望手动初始化或监控完成情况，请连接到`initialization_complete`信号：

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("initialization_complete", self, "_on_AdMob_initialization_complete")
        MobileAds.initialize()

    func _on_AdMob_initialization_complete(status: int, adapter_name: String) -> void:
        print("AdMob Initialized: ", status)
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("initialization_complete", this, nameof(_on_AdMob_initialization_complete));
        MobileAds.Call("initialize");
    }

    private void _on_AdMob_initialization_complete(int status, string adapterName)
    {
        GD.Print("AdMob Initialized: " + status);
    }
    ```

---

## 选择广告格式

SDK初始化后，您可以选择并实现最适合游戏布局的广告格式：

* [横幅广告](ad_formats/banner.zh.md)
* [插页广告](ad_formats/interstitial.zh.md)
* [激励视频广告](ad_formats/rewarded.zh.md)
* [激励插页广告](ad_formats/rewarded_interstitial.zh.md)