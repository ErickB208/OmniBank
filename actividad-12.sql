
SELECT
    t.transaction_id,
    t.account_id,
    t.amount,
    (
        SELECT AVG(t2.amount)
        FROM transactions AS t2
        WHERE t2.account_id = t.account_id
    ) AS promedio_cuenta
FROM transactions AS t
WHERE t.amount > (
    SELECT AVG(t2.amount)
    FROM transactions AS t2
    WHERE t2.account_id = t.account_id
)
ORDER BY t.account_id, t.transaction_id;

SELECT
    account_id,
    COUNT(*) AS total_movimientos,
    AVG(amount) AS promedio_cuenta
FROM transactions
GROUP BY account_id
ORDER BY account_id;

SELECT
    a.account_number,
    a.is_active
FROM accounts AS a
WHERE NOT EXISTS (
    SELECT 1
    FROM transactions AS t
    WHERE t.account_id = a.account_id
)
ORDER BY a.account_number;
