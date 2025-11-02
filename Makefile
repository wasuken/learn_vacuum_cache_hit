.PHONY: help up down build ps run logs clean test check

help: ## ヘルプを表示
	@echo "使用可能なコマンド:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-10s\033[0m %s\n", $$1, $$2}'

up: ## コンテナを起動
	docker-compose up -d

down: ## コンテナを停止・削除
	docker-compose down

build: ## イメージをビルドして起動
	docker-compose up -d --build

ps: ## コンテナの状態を確認
	docker-compose ps

run: ## PostgreSQLに接続
	docker-compose exec postgres psql -U testuser -d testdb

test: ## テストクエリを実行
	docker-compose exec -T postgres psql -U testuser -d testdb < test_queries.sql

check: ## キャッシュヒット率を確認
	docker-compose exec -T postgres psql -U testuser -d testdb < check_cache.sql

logs: ## ログを表示
	docker-compose logs -f postgres

clean: ## コンテナとボリュームを削除
	docker-compose down -v