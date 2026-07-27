-- Test hypothetical indexes with hypopg

-- Skip test if hypopg is not installed.
SELECT count(*) = 0 AS hypopg_missing FROM pg_available_extensions
  WHERE name = 'hypopg' \gset
\if :hypopg_missing
\quit
\endif

LOAD 'pg_hint_plan';

CREATE EXTENSION hypopg;
CREATE TABLE hypopg_t1(a int, b int, c int);
CREATE INDEX hypopg_t1_a_idx ON hypopg_t1 (a);
SELECT hypopg_create_index('CREATE INDEX hypopg_t1_b_idx ON hypopg_t1 (b)');

EXPLAIN (COSTS OFF) SELECT /*+ IndexScan(hypopg_t1 hypopg_t1_a_idx) */
  FROM hypopg_t1 WHERE a = 3 AND b = 4;
EXPLAIN (COSTS OFF) SELECT /*+ IndexScan(hypopg_t1 hypopg_t1_b_idx) */
  FROM hypopg_t1 WHERE a = 3 AND b = 4;
EXPLAIN (COSTS OFF) SELECT /*+ IndexScan(hypopg_t1 btree_hypopg_t1_b) */
  FROM hypopg_t1 WHERE a = 3 AND b = 4;

DROP TABLE hypopg_t1;
DROP EXTENSION hypopg;
