
SELECT
    t1.account_id,
    t1.transaction_id AS movimiento_1,
    t1.tx_timestamp AS fecha_1,
    t1.amount AS importe_1,
    t2.transaction_id AS movimiento_2,
    t2.tx_timestamp AS fecha_2,
    t2.amount AS importe_2
FROM transactions AS t1
INNER JOIN transactions AS t2
    ON t1.account_id = t2.account_id
   AND t1.transaction_id < t2.transaction_id
   AND ABS(
       EXTRACT(
           EPOCH FROM (t2.tx_timestamp - t1.tx_timestamp)
       )
   ) <= 48 * 60 * 60
ORDER BY t1.account_id, movimiento_1, movimiento_2;

SELECT
    e.enumlabel AS tipo_cuenta
FROM pg_enum AS e
INNER JOIN pg_type AS t
    ON e.enumtypid = t.oid
INNER JOIN pg_namespace AS n
    ON t.typnamespace = n.oid
WHERE n.nspname = 'core'
  AND t.typname = 'tipo_cuenta'
ORDER BY e.enumsortorder;
