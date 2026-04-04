## Context

WebPageStockは新規iOSアプリ（iOS 26+ / SwiftUI / SwiftData）。現時点でコードベースは空の状態であり、ゼロからの構築となる。ユーザーがアプリ内でWebページを閲覧し、お気に入りページを保存・管理できるシンプルなブラウザ＋ブックマークアプリを構築する。

## Goals / Non-Goals

**Goals:**
- アプリ内WebViewで快適にWebブラウジングできること
- ワンタップでページを保存し、メイン画面の一覧で管理できること
- 保存済みURLにメモを付けられること
- SwiftDataによるシンプルなローカル永続化

**Non-Goals:**
- iCloud同期やマルチデバイス対応（将来検討）
- タグ・フォルダによる分類機能（MVPスコープ外）
- ページのオフライン保存・スクリーンショット保存
- Safari拡張やShare Extensionとの連携
- 検索機能（MVPスコープ外）

## Decisions

### 1. WebView実装: WKWebView + UIViewRepresentable

**選択**: WKWebViewをUIViewRepresentableでラップする
**理由**: iOS 26時点でSwiftUI純正のWebViewコンポーネントは存在しない。WKWebViewは最も成熟したWebレンダリングエンジンであり、ナビゲーション制御（戻る・進む・リロード）のAPIが充実している。
**代替案**: SFSafariViewControllerは閲覧専用で、ナビゲーション制御やURL取得のカスタマイズ性が低いため不採用。

### 2. データ永続化: SwiftData

**選択**: SwiftData（@Model）
**理由**: iOS 17+で利用可能、SwiftUIとの統合がネイティブで@Queryによるリアクティブな一覧表示が容易。READMEでも明示されている技術選定。
**代替案**: Core Dataは冗長なボイラープレートが必要。UserDefaultsは構造化データに不向き。

### 3. 画面構成: TabViewベースの2画面構成

**選択**: TabViewで「ブックマーク一覧」と「ブラウザ」の2タブ構成
**理由**: ブラウザで閲覧中にいつでもブックマーク一覧に切り替えられ、またブックマーク一覧からタップで該当ページをブラウザで開ける。ユーザーの操作フローが自然になる。
**代替案**: NavigationStackでpush/pop方式にすると、ブラウザとリストの行き来にバックボタン操作が必要で煩雑。

### 4. データモデル設計

```
@Model Bookmark
├── id: UUID
├── url: String
├── title: String
├── memo: String (デフォルト空文字)
├── createdAt: Date
└── updatedAt: Date
```

**選択**: 単一モデルでURL・タイトル・メモ・タイムスタンプを管理
**理由**: MVPとしてはシンプルな1モデルで十分。メモは独立エンティティにせず、Bookmarkの属性として保持することで複雑性を排除する。

### 5. ブラウザ→保存のフロー

**選択**: ブラウザ画面のツールバーに「保存」ボタンを配置。タップ時に現在のURL・タイトルを取得しSwiftDataに保存。
**理由**: ワンタップで保存を実現するため、閲覧中に常にアクセス可能な位置にボタンを配置する。保存済みの場合はボタン状態を変更して重複保存を視覚的に防ぐ。

## Risks / Trade-offs

- **[WKWebViewのSwiftUI統合の複雑さ]** → Coordinator パターンで navigation delegate を適切に管理し、@Bindingで状態を同期する
- **[大量ブックマーク時のパフォーマンス]** → SwiftDataの@Queryはlazy fetchをサポートしており、MVPスコープでは問題にならない見込み
- **[WebViewのメモリ使用量]** → 単一WebViewインスタンスで運用し、バックグラウンド時のメモリ管理はOSに委ねる
