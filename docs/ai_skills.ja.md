# AI Copilot スキル (ベータ版)

AI Copilot スキル（AI Copilot Skills）を使用すると、AIを活用したコーディングアシスタント（AntigravityのGemini、Cursor、Claude、GitHub Copilotなど）をゲーム開発ワークフローに統合できます。

AdMobプラグインには、さまざまな広告フォーマット（バナー、インタースティシャル、リワード広告など）を **GDScript** と **C#** の両方で統合するためのすべての仕様、API、およびコードパターンを含む、事前設定されたAIスキルが付属しています。

---

## クイックインストール（組み込みスキル）

事前設定されたAdMob AIスキルは、ワンクリックでプロジェクトに直接インストールできます。

1. Godotプロジェクトを開きます。
2. エディタの上部メニューで、**Project -> Tools -> AdMob Manager** をクリックします。
3. **AI Copilot** サブメニューを選択します。
4. **Install AI Skills to Project** をクリックします。

これにより、プロジェクトのルートディレクトリに `.skills/godot-admob-copilot` フォルダが自動的に作成され、その中に `SKILL.md` 指示ファイルが配置されます。

!!! note
    ドットで始まるファイルやフォルダ（`.skills`など）は、ワークスペースの混雑を避けるためにGodotのFileSystemドックではデフォルトで非表示になっていますが、外部IDE（VS Code、Cursor、Antigravityなど）からは完全に表示されます。

---

## プロンプトでスキルを呼び出す

プロジェクトにスキルを追加した後、以下のプロンプト例を使用してAIツールで呼び出します。

スキルを呼び出すには、`@` を入力して `godot-admob-copilot` スキルを選択します。

=== "MobileAdsの初期化"

    ```text
    @godot-admob-copilot GDScriptでMobileAdsを初期化する前に、UMP同意情報を確認することを含む完全な初期化フローを作成してください。
    ```

=== "バナー広告の追加"

    ```text
    @godot-admob-copilot GDScriptで画面下部に標準のアダプティブバナーを作成して表示する方法を教えてください。
    ```

=== "リワード広告の追加"

    ```text
    @godot-admob-copilot C#でリワード広告をロードし、ユーザーが広告の視聴を完了したときにプレイヤーに100ゴールドを与えるコールバックを実装するのを手伝ってください。
    ```

