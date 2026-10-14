
SELECT
    a.account_number,
    a.account_type,
    c.name AS titular
FROM accounts AS a
INNER JOIN customers AS c
    ON c.customer_id = a.customer_id
WHERE a.is_active = TRUE
  AND NOT EXISTS (
      SELECT 1
      FROM transactions AS t
      WHERE t.account_id = a.account_id
        AND t.tx_type = 'DEPOSIT'
  )
ORDER BY a.account_number;

SELECT
    a.account_number,
    a.account_type,
    c.name AS titular,
    COUNT(t.transaction_id) AS total_movimientos
FROM accounts AS a
INNER JOIN customers AS c
    ON c.customer_id = a.customer_id
INNER JOIN transactions AS t
    ON t.account_id = a.account_id
WHERE a.is_active = TRUE
GROUP BY
    a.account_id,
    a.account_number,
    a.account_type,
    c.name
ORDER BY a.account_number;
