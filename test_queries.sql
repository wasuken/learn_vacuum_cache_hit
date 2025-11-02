-- キャッシュヒット率テスト用のクエリ

-- 1. フルスキャンでキャッシュを温める
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM orders;

-- 2. JOIN クエリ（インデックスとテーブルの両方を使用）
SELECT u.name, COUNT(o.id) as order_count, SUM(o.amount) as total_amount
FROM users u
LEFT JOIN orders o ON u.id = o.user_id
GROUP BY u.id, u.name
ORDER BY total_amount DESC
LIMIT 100;

-- 3. 条件付き検索（インデックススキャン）
SELECT * FROM users WHERE email LIKE 'user1%';
SELECT * FROM orders WHERE status = 'completed' AND created_at > NOW() - INTERVAL '30 days';

-- 4. 集計クエリ（ワーキングメモリを使用）
SELECT 
    DATE_TRUNC('day', created_at) as day,
    status,
    COUNT(*) as count,
    AVG(amount) as avg_amount
FROM orders
GROUP BY day, status
ORDER BY day DESC;

-- 5. 複雑な JOIN とソート（メモリ負荷）
SELECT 
    u.name,
    u.email,
    o.amount,
    o.status,
    o.created_at
FROM users u
INNER JOIN orders o ON u.id = o.user_id
WHERE o.amount > 500
ORDER BY o.amount DESC, o.created_at DESC
LIMIT 1000;

-- 統計情報をリセット（オプション）
-- SELECT pg_stat_reset();
