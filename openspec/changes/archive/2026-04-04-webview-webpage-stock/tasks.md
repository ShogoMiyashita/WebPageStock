## 1. プロジェクトセットアップ

- [x] 1.1 Xcodeプロジェクトを作成し、iOS 26+ / SwiftUI App ライフサイクルで初期構成する
- [x] 1.2 SwiftDataのModelContainerをAppエントリポイントで設定する

## 2. データモデル

- [x] 2.1 Bookmark @Modelを定義する（id, url, title, memo, createdAt, updatedAt）

## 3. WebViewブラウザ

- [x] 3.1 WKWebViewをラップするUIViewRepresentable（WebView）を実装する
- [x] 3.2 Coordinatorを実装し、WKNavigationDelegateでURL・タイトル・読み込み進捗を@Bindingに同期する
- [x] 3.3 BrowserView（ブラウザ画面）を実装する：URL入力フィールド、ProgressView、WebView、ツールバー（戻る・進む・リロード・保存ボタン）
- [x] 3.4 URL入力のバリデーション：有効なURLはそのまま読み込み、無効な入力はGoogle検索クエリとして処理する

## 4. ブックマーク保存機能

- [x] 4.1 BrowserViewの保存ボタンタップ時に、現在のURL・タイトルからBookmarkを作成しSwiftDataに保存するロジックを実装する
- [x] 4.2 現在のURLが保存済みかどうかを判定し、保存ボタンの状態（未保存/保存済み）を切り替える

## 5. ブックマーク一覧画面

- [x] 5.1 BookmarkListView（メイン一覧画面）を実装する：@QueryでBookmarkを保存日時降順に取得しList表示する
- [x] 5.2 各行にタイトル・URL・保存日時・メモプレビュー（メモがある場合のみ）を表示する
- [x] 5.3 空状態の表示を実装する（ContentUnavailableView）
- [x] 5.4 スワイプ削除を実装する（.onDelete）

## 6. メモ機能

- [x] 6.1 MemoEditView（メモ編集シート）を実装する：TextEditorでメモ入力、保存ボタンでSwiftDataに永続化
- [x] 6.2 一覧画面の各行にメモ編集ボタンを配置し、タップでMemoEditViewをシート表示する

## 7. 画面統合・ナビゲーション

- [x] 7.1 TabViewで「ブックマーク一覧」と「ブラウザ」の2タブ構成を実装する
- [x] 7.2 一覧からブックマークタップ時にブラウザタブへ切り替えて該当URLを読み込む連携を実装する

## 8. 動作確認

- [x] 8.1 ビルドが成功し、シミュレータでアプリが起動することを確認する
- [ ] 8.2 WebViewでのページ閲覧 → 保存 → 一覧表示 → メモ追加 → 削除の一連フローが動作することを確認する
