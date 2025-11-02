# PostgreSQL メモリチューニング検証環境

PostgreSQLのキャッシュヒット率とメモリ使用状況を確認するための検証環境です。

## セットアップ

### 1. 環境起動
```bash
make build
```

### 2. データ確認
```bash
make run
# PostgreSQLに接続後
\dt  # テーブル一覧
SELECT COUNT(*) FROM users;   # 100,000件
SELECT COUNT(*) FROM orders;  # 500,000件
\q   # 終了
```

## 使い方

### 1. テストクエリ実行（キャッシュを温める）
```bash
make test
```

### 2. キャッシュヒット率確認
```bash
make check
```

### 3. 結果の見方
- **テーブルのキャッシュヒット率**: 99%以上が理想
- **インデックスのキャッシュヒット率**: 99%以上が理想
- **テンポラリファイル**: 使用量が多い場合は `work_mem` 不足

## その他のコマンド

```bash
make help   # コマンド一覧
make ps     # コンテナ状態確認
make logs   # ログ表示
make down   # 停止
make clean  # 完全削除（データも消える）
```

## ファイル構成

```
.
├── docker-compose.yml   # Docker設定
├── init.sql            # 初期データ作成
├── test_queries.sql    # 負荷テスト用クエリ
├── check_cache.sql     # キャッシュ確認クエリ
├── Makefile            # 操作コマンド
└── README.md           # このファイル
```
