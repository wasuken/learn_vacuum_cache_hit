-- テストデータベースの初期化

-- テスト用テーブルの作成
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- インデックスの作成
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_orders_user_id ON orders(user_id);
CREATE INDEX idx_orders_created_at ON orders(created_at);

-- ダミーデータの挿入（メモリ負荷テスト用）
INSERT INTO users (name, email)
SELECT 
    'User ' || i,
    'user' || i || '@example.com'
FROM generate_series(1, 100000) AS i;

INSERT INTO orders (user_id, amount, status)
SELECT 
    (random() * 99999 + 1)::INTEGER,
    (random() * 1000)::DECIMAL(10, 2),
    CASE 
        WHEN random() < 0.3 THEN 'pending'
        WHEN random() < 0.7 THEN 'completed'
        ELSE 'cancelled'
    END
FROM generate_series(1, 500000) AS i;

-- 統計情報の更新
ANALYZE users;
ANALYZE orders;
