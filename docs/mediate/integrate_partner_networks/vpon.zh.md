# Vpon

Vpon 移动广告中介适配器允许您通过 AdMob 中介将 Vpon 广告集成到您的 Godot 游戏中。

## 支持的广告格式

| 广告格式 | Bidding | Waterfall |
| :--- | :--- | :--- |
| **横幅广告 (Banner)** | ❌ | |
| **插页式广告 (Interstitial)** | ❌ | |
| **激励广告 (Rewarded)** | ❌ | |

## 集成步骤

### Android

#### 1. 在项目设置中启用 Vpon
- 在 Godot 项目设置的 `admob/android/mediation/vpon` 下启用 **Vpon**。

#### 2. 在 AdMob 控制台中配置中介
在 AdMob 控制台中将 Vpon 配置为中介合作伙伴：
1. 登录您的 **AdMob 帐户**。
2. 导航至**中介**，创建或编辑**中介组**。
3. 在广告网络瀑布流中，将 Vpon 添加为**自定义事件**。
4. **类名**：输入 `com.vpadn.mediation.VpadnAdapter`。
5. **参数**：输入您的 Vpon 许可证密钥。

---

### iOS

由于 Vpon 在 iOS 上通过自定义事件集成，开发者需要在导出时将 Vpon SDK 和 AdMob 适配器框架文件添加到 Xcode 构建设置中。

#### 1. 在 AdMob 控制台中配置中介
1. 登录您的 **AdMob 帐户**。
2. 导航至**中介**，创建或编辑**中介组**。
3. 在广告网络瀑布流中，将 Vpon 添加为**自定义事件**。
4. **类名**：输入 `VponAdMobAdapter`。
5. **参数**：输入您的 Vpon 许可证密钥 / 广告单元 ID。
