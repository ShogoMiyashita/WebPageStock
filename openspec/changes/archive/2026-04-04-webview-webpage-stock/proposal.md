## Why

ユーザーがアプリ内でWebページを閲覧し、気になったページをワンタップで保存できる仕組みが必要。外部ブラウザとの切り替えなしに、発見・保存・管理を一つのアプリ内で完結させることで、情報収集のフリクションを最小化する。

## What Changes

- アプリ内WebViewブラウザを追加し、URL入力・ページ遷移・戻る/進むのナビゲーションを提供する
- 閲覧中のページをワンタップで保存する機能を追加する（URL、ページタイトル、保存日時を記録）
- メイン画面に保存済みURLの一覧をリスト表示する
- 各保存済みURLにユーザーがメモ（テキスト）を追加・編集できる機能を追加する
- 保存済みURLを削除できる機能を追加する
- SwiftDataによるローカルデータ永続化を導入する

## Capabilities

### New Capabilities

- `webview-browser`: アプリ内WebViewブラウザ。URL入力、ページ表示、ナビゲーション（戻る・進む・リロード）を提供する
- `bookmark-management`: Webページの保存・一覧表示・削除を管理する。メイン画面のリスト表示を含む
- `bookmark-memo`: 保存済みURLへのメモ（テキスト）の追加・編集機能

### Modified Capabilities

（既存のCapabilityはないため、該当なし）

## Impact

- **新規コード**: SwiftUIビュー群（メイン一覧画面、WebViewブラウザ画面、メモ編集画面）、SwiftDataモデル、WebKit連携のUIViewRepresentable
- **依存フレームワーク**: WebKit（WKWebView）、SwiftData
- **対象OS**: iOS 26+
