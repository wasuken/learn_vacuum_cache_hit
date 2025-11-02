-- check_cache.sql
-- キャッシュヒット率とメモリ使用状況の確認

\echo '========================================='
\echo 'テーブルのキャッシュヒット率'
\echo '========================================='
SELECT
  sum(heap_blks_read) as heap_read,
  sum(heap_blks_hit) as heap_hit,
  CASE 
    WHEN sum(heap_blks_hit) + sum(heap_blks_read) = 0 THEN 0
    ELSE round(sum(heap_blks_hit) / (sum(heap_blks_hit) + sum(heap_blks_read))::numeric * 100, 2)
  END as cache_hit_ratio_percent
FROM pg_statio_user_tables;

\echo ''
\echo '========================================='
\echo 'インデックスのキャッシュヒット率'
\echo '========================================='
SELECT
  sum(idx_blks_read) as idx_read,
  sum(idx_blks_hit) as idx_hit,
  CASE 
    WHEN sum(idx_blks_hit) + sum(idx_blks_read) = 0 THEN 0
    ELSE round(sum(idx_blks_hit) / (sum(idx_blks_hit) + sum(idx_blks_read))::numeric * 100, 2)
  END as idx_cache_hit_ratio_percent
FROM pg_statio_user_indexes;

\echo ''
\echo '========================================='
\echo 'ワーキングメモリ設定'
\echo '========================================='
SELECT name, setting, unit
FROM pg_settings
WHERE name IN ('work_mem', 'shared_buffers', 'effective_cache_size', 'maintenance_work_mem');

\echo ''
\echo '========================================='
\echo 'テンポラリファイル使用状況'
\echo '========================================='
SELECT 
  datname,
  temp_files,
  pg_size_pretty(temp_bytes) as temp_size
FROM pg_stat_database
WHERE datname = 'testdb';
