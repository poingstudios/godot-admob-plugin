# 列挙型と設定

!!! note "Godot 3 (v1) ドキュメント"
    このページは **Godot 3.x** 用です。**Godot 4.2+** については、[安定版ドキュメント](https://poingstudios.github.io/godot-admob-plugin/stable/) をご覧ください。

このページには、Godot 3のGodot AdMobプラグインで使用されるパブリック列挙型と設定がリストされています。

---

## INITIALIZATION_STATUS

Google Mobile Ads SDKの準備ステータスを定義します。

- `NOT_READY` = `0`
- `READY` = `1`

---

## POSITION

画面でのバナー広告の位置を定義します。

- `BOTTOM` = `0`
- `TOP` = `1`

---

## BANNER_SIZE

AdMobエディタパネルの設定で構成されたバナーサイズ：

- `"BANNER"`（スタンダードバナー：320x50）
- `"MEDIUM_RECTANGLE"`（中長方形：300x250）
- `"FULL_BANNER"`（フルバナー：468x60）
- `"LEADERBOARD"`（リーダーボード：728x90）
- `"ADAPTIVE"`（アンカードアダプティブバナー）
- `"SMART_BANNER"`（スマートバナー：非推奨）