# Sengoku Maze

Perron（Railsベースの静的サイトジェネレータ）を用いて構築する、
**戦国時代の人物・出来事・場所を「関係性」で辿れる静的サイト**の実験プロジェクト。

ブログ形式ではなく、Markdownで定義されたコンテンツ同士を
frontmatter のメタデータによって相互接続し、
探索型のナレッジサイトを構築することを目的とする。

---

## 概要

このプロジェクトは以下を検証・実践するためのものです。

* Railsアプリケーションをそのまま静的サイトへビルドする Perron の活用
* Markdown + frontmatter によるコンテンツ管理
* メタデータを元にした自動リンク生成
* 「時系列」ではなく「関係性」に基づくページ遷移設計
* GitHub Pages へのデプロイを前提としたCI/CD構成

---

## コンテンツ構造

各ページは Markdown ファイルで管理し、
frontmatter にメタデータを持たせる。

```yaml
title: 明智光秀
era: 戦国
related:
  - 織田信長
  - 本能寺の変
  - 山崎の戦い
```

この `related` 情報を Rails 側で解釈し、
該当ページへのリンクを自動生成する。

これにより、最小限の記述で「関係性のネットワーク」を形成できる。

---

## 技術スタック

* Ruby on Rails
* Perron
* Markdown
* GitHub Pages

開発時は通常の Rails アプリとして動作させ、
`bin/rails perron:build` により静的HTMLを生成する。

---

## 本番環境

https://maangie.github.io/gunyuuden/

`main` ブランチに push すると、GitHub Actions（`.github/workflows/pages.yml`）が
次の手順で自動的にデプロイする。

1. `yarn build:css` で CSS をビルドする
2. `bin/rails perron:build` で静的サイトを `output/` に生成する
3. HTML 内のルート絶対パス（`/...`）の先頭に `/gunyuuden/` を付ける
4. `output/` を GitHub Pages にデプロイする

プロジェクトサイトはリポジトリ名のサブディレクトリ配下で配信されるため、
3 の書き換えが必要になる。

手動で再デプロイする場合は、Actions の「GitHub Pages へデプロイ」を
`workflow_dispatch` で実行する（`gh workflow run pages.yml`）。

---

## 目的

* Perron を用いた静的サイト構築フローの理解
* Rails のルーティング／ビュー／モデルを活用したSSG設計の検証
* データ駆動型のページ生成とリンク構造の実装
* 小規模な知識グラフをWebサイトとして表現する試み

---

## エントリーポイント

最初のコンテンツは「明智光秀」から開始する。
