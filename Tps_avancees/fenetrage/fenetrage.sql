-- SQLite
SELECT 
  *,
  SUM(profit) OVER () as total,
  SUM(profit) OVER w as total_country,
  RANK() OVER w as rank,
  ROW_NUMBER() OVER w as idx
FROM sales
WINDOW w AS (PARTITION BY country ORDER BY profit DESC)