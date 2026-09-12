# 広告ソースの選択

AdMob メディエーションは、入札 (Bidding) とウォーターフォール (Waterfall) の両方の統合方法に対応する複数の広告ソースをサポートしています。広告ソースをクリックすると、その広告ソース専用の統合手順が表示されます。

<table class="admob-matrix-table" id="network-details">
  <thead>
    <tr>
      <th style="width: 17%;">広告ソース</th>
      <th style="width: 8%;">App<br>Open</th>
      <th style="width: 8%;">Banner</th>
      <th style="width: 10.5%;">Interstitial</th>
      <th style="width: 9%;">Rewarded</th>
      <th style="width: 11%;">Rewarded<br>Interstitial</th>
      <th style="width: 8%;">Native</th>
      <th style="width: 8.5%;">Bidding</th>
      <th style="width: 20%;">広告ソースの最適化<br>サポート</th>
    </tr>
  </thead>
  <tbody>
    <tr class="table-section-row">
      <th colspan="9">オープンソースでバージョン管理済み - サードパーティ SDK が必要</th>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/applovin.md">AppLovin</a></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td>国固有</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/bidmachine.md">BidMachine</a></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>なし</td>
    </tr>
    <tr>
      <td><a href="https://developers.google.com/admob/ios/mediation/bigo" target="_blank">BIGO Ads SDK</a></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>なし</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/chartboost.md">Chartboost</a></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td></td>
      <td>国固有</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/dtexchange.md">DT Exchange</a></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span><a class="footnote" href="#bidding-footnote"><sup>1</sup></a></td>
      <td>国固有</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/imobile.md">i-mobile</a></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td>日本のみ</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/inmobi.md">InMobi</a></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span><a class="footnote" href="#bidding-footnote"><sup>1</sup></a></td>
      <td>国固有</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/ironsource.md">ironSource Ads</a></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span><a class="footnote" href="#bidding-footnote"><sup>1</sup></a></td>
      <td>国固有</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/vungle.md">Liftoff Monetize</a></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>国固有</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/line.md">LY Ads Network</a></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>国固有</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/maio.md">maio</a></td>
      <td></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td></td>
      <td>日本のみ</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/meta.md">Meta Audience Network</a></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/mintegral.md">Mintegral</a></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>国固有</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/moloco.md">Moloco</a></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>国固有</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/mytarget.md">myTarget</a></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td>国固有</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/pangle.md">Pangle</a></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>国固有</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/pubmatic.md">PubMatic OpenWrap</a></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span><a class="footnote" href="#format-beta-sdkb-footnote"><sup>2</sup></a></td>
      <td><span class="table-check">✓</span><a class="footnote" href="#format-beta-sdkb-footnote"><sup>2</sup></a></td>
      <td></td>
      <td><span class="table-check">✓</span><a class="footnote" href="#format-beta-sdkb-footnote"><sup>2</sup></a></td>
      <td><span class="table-check">✓</span></td>
      <td>国固有</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/unity_ads.md">Unity Ads</a></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td><span class="table-check">✓</span><a class="footnote" href="#bidding-footnote"><sup>1</sup></a></td>
      <td>国固有</td>
    </tr>
    <tr class="table-section-row">
      <th colspan="9">非オープンソース - サードパーティ SDK が必要</th>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/vpon.md">Vpon</a></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td>なし</td>
    </tr>
    <tr>
      <td><a href="integrate_partner_networks/zucks.md">Zucks</a></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
      <td>国固有</td>
    </tr>
    <tr class="table-section-row">
      <th colspan="9">サードパーティ SDK は不要</th>
    </tr>
    <tr>
      <td>Ad Generation</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Bidease</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Chocolate Platform</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Equativ (formerly Smart Adserver)</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Fluct</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Improve Digital</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Index Exchange</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>InMobi Exchange</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Magnite DV+</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Media.net</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>MobFox</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Nativo</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Nexxen (previously UnrulyX)</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>OneTag Exchange</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>OpenX</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>PubMatic</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Rise</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Sharethrough</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Smaato</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Sonobi</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>TripleLift</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Verve Group</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>Yieldmo</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
    <tr>
      <td>YieldOne</td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td><span class="table-check">✓</span></td>
      <td></td>
      <td></td>
      <td><span class="table-check">✓</span></td>
      <td>入札のみ</td>
    </tr>
  </tbody>
</table>

<p class="table-footnotes">
  <span id="bidding-footnote"><sup>1</sup></span> 入札 (Bidding) の統合はベータ版です。<br>
  <span id="format-beta-sdkb-footnote"><sup>2</sup></span> このフォーマットはベータ版です (SDK 入札)。
</p>

!!! note "注"
    広告ソースはアルファベット順に並んでいます。

## オープンソースでバージョン管理されたアダプター

上記テーブルで「オープンソースでバージョン管理済み」と記載されているアダプターは、Google の GitHub リポジトリ（[Android](https://github.com/googleads/googleads-mobile-android-mediation){:target="_blank"} または [iOS](https://github.com/googleads/googleads-mobile-ios-mediation){:target="_blank"}）でソースコードが公開されており、必要に応じてご自身で問題をデバッグできます。

各アダプターは、サードパーティ広告ネットワーク SDK の特定バージョン向けにビルドされています。詳細は各パートナーの統合ガイドをご確認ください。

### アダプターのバージョニング

Godot アダプターは、該当広告ネットワークの基盤となる Android および iOS SDK 依存関係をモデルにした `<major>.<minor>.<patch>` バージョニング規則に従います。Android または iOS の依存関係がメジャーまたはマイナーアップデートされた場合、Godot アダプターも対応してアップデートされます。その他のリリースはパッチバージョンが上がります。

!!! important "重要"
    AdMob メディエーションで使用するバナー広告ユニットについては、すべてのサードパーティ広告ネットワークの管理画面で自動更新（リフレッシュ）を必ず無効にしてください。AdMob 側でもバナーのリフレッシュレートに基づいて更新が実行されるため、二重更新を防ぐことができます。

## 広告ソースの最適化

メディエーション用に複数の広告ネットワークを設定する場合、各ネットワークの CPM を設定してリクエスト順序を指定する必要があります。広告ネットワークの掲載結果は時間とともに変化するため、手動管理が難しくなることがあります。

[広告ソースの最適化](https://support.google.com/admob/answer/7388022){:target="_blank"} は、メディエーション チェーンの順序付けプロセスを自動化して収益を最大化し、チェーン内の広告ネットワークから最大の CPM を生み出す機能です。

上記の[メディエーション ネットワーク テーブル](#network-details)では、最適化サポートに以下の値を使用しています。

| 広告ソースの最適化サポート | 意味 |
| :--- | :--- |
| `入札のみ` | 広告ネットワークは入札のみに参加します。広告ソースの最適化は適用されません。 |
| `国固有` | 国ごとに eCPM 値が自動的に更新されます。これは最も最適な最適化タイプです。 |
| `なし` | その広告ネットワークの eCPM 値を手動で設定する必要があります。 |

広告ソースの最適化を設定する手順については、各広告ネットワークのガイドをご覧ください。

!!! note "注"
    **オープンソースでバージョン管理済み**の広告ネットワークのみ、広告ソースの最適化を設定するための手順が用意されています。

## カスタム イベント

使用したい広告ネットワークが上記リストに見当たらない場合は、カスタム イベントを使用してその広告ネットワーク独自の統合を作成できます。詳細は Google の[カスタム イベント ガイド](https://developers.google.com/admob/android/mediation/custom-events){:target="_blank"}をご確認ください。

!!! note "注"
    カスタム イベントには、広告ソースの最適化や入札 (Bidding) のサポートはありません。
