# エディタでのモック広告のプレビュー

プラグインには内蔵のモック広告システムが含まれています。これにより、物理デバイスにデプロイせずに、Godotエディタ内で広果統合のビジュアルレイアウトとロジックフローを直接テストできます。

モック広告は広告の動作をシミュレートし、実際のモバイルSDKとまったく同じライフサイクルコールバック（ロード、表示、クリック、解除など）を発火します。

---

## 仕組み

プラグインは、Godotエディタ内でゲームがデスクトッププラットフォーム（Windows、macOS、Linux）で実行されていることを自動的に検出します。AndroidまたはiOSのネイティブシングルトンが欠落していることで失敗する代わりに、プラグインはモックシングルトンとノードを自動的にインスタンス化します。

C#またはGDScriptのコードを変更する必要はありません。すべての標準的な`MobileAds`シングルトンAPIはまったく同じように機能します。

---

## サポートされているフォーマット

モックシステムは以下の広告フォーマットのビジュアル外観とインタラクションをシミュレートします：

### バナー
- 設定された位置とサイズ（スタンダード、ラージ、中長方形、リーダーボード）に一致するモックバナーコンテナを画面にレンダリング。
- 解除をシミュレートする閉じるボタン（`×`）を含む。

### インタースティシャル
- フルスクリーンのインタースティシャルオーバーレイをレンダリング。
- 広告を非表示にし、`interstitial_closed`コールバックを発火する閉じるボタン（`X`）を含む。

### リワードおよびリワードインタースティシャル
- フルスクリーンのリワード動画シミュレーションをレンダリング。
- シミュレートされた動画カウントダウンタイマーを再生。
- カウントダウン完了時に自動的に`user_earned_rewarded`コールバックを発火。
- ゲームに戻るための閉じるボタン（`X`）を表示。

---

## ライフサイクルコールバックのデバッグ

モックプラグインは実際のモバイルSDKとまったく同じシグナルを発火します：

=== "GDScript"

    ```gdscript
    func _ready() -> void:
        MobileAds.connect("interstitial_loaded", self, "_on_interstitial_loaded")
        MobileAds.connect("interstitial_closed", self, "_on_interstitial_closed")
        MobileAds.load_interstitial()

    func _on_interstitial_loaded() -> void:
        print("Ad loaded in Editor!")
        MobileAds.show_interstitial()

    func _on_interstitial_closed() -> void:
        print("Ad dismissed in Editor!")
    ```

=== "C#"

    ```csharp
    public override void _Ready()
    {
        MobileAds.Connect("interstitial_loaded", this, nameof(_on_interstitial_loaded));
        MobileAds.Connect("interstitial_closed", this, nameof(_on_interstitial_closed));
        MobileAds.Call("load_interstitial");
    }

    private void _on_interstitial_loaded()
    {
        GD.Print("Ad loaded in Editor!");
        MobileAds.Call("show_interstitial");
    }

    private void _on_interstitial_closed()
    {
        GD.Print("Ad dismissed in Editor!");
    }
    ```