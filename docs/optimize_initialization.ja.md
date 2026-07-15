# 初期化と広告読み込みの最適化

このガイドでは、Godot プロジェクトで初期化と広告読み込みを最適化する方法について説明します。

## Google Mobile Ads 設定を更新する

Google Mobile Ads Godot プラグインはデフォルトで最適化を有効にし、バックグラウンドスレッドで初期化および広告読み込みタスクを実行するよう SDK に指示します。

以下のオプションは Godot のプロジェクト設定で使用できます：

* 初期化最適化を無効にする
* 広告読み込み最適化を無効にする

SDK にメインスレッドで初期化と広告読み込みを行わせるには、これらの設定をチェックします：

| 設定 | 動作 |
| :--- | :--- |
| **Disable Initialization Optimization** | `MobileAds.initialize()` 初期化呼び出しの最適化を無効にします。 |
| **Disable Ad Loading Optimization** | すべての広告フォーマットに対する広告読み込み呼び出しの最適化を無効にします。 |

Godot のプロジェクト設定メニューから Google Mobile Ads 設定にアクセスできます：

**Project > Project Settings > Admob > General > Android**

選択すると、設定 UI が **Android** セクションの下に表示されます：

![初期化最適化設定](assets/optimize_initialization.png)
