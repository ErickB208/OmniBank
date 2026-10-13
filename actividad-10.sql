
SELECT
    account_type,
    COUNT(*) AS cantidad_cuentas_activas,
    SUM(balance) AS saldo_total_almacenado,
    MIN(balance) AS saldo_minimo_almacenado,
    MAX(balance) AS saldo_maximo_almacenado,
    AVG(balance) AS saldo_promedio_almacenado
FROM core.accounts
WHERE is_active = TRUE
GROUP BY account_type
ORDER BY
    saldo_total_almacenado DESC,
    account_type;


SELECT
    c.customer_id,
    c.email,
    COUNT(t.transaction_id) AS cantidad_movimientos,
    COALESCE(SUM(t.amount), 0) AS volumen_bruto_registrado
FROM core.customers AS c
LEFT JOIN core.accounts AS a
    ON c.customer_id = a.customer_id
LEFT JOIN core.transactions AS t
    ON a.account_id = t.account_id
GROUP BY
    c.customer_id,
    c.email
HAVING
    COUNT(t.transaction_id) >= 2
    OR COALESCE(SUM(t.amount), 0) > 100
ORDER BY
    volumen_bruto_registrado DESC,
    c.email;



SELECT
    account_id,
    COUNT(transaction_id) AS cantidad_movimientos,
    SUM(amount) AS volumen_bruto_registrado
FROM core.transactions
GROUP BY account_id
ORDER BY account_id;



SELECT
    COUNT(transaction_id) AS total_movimientos,
    SUM(amount) AS volumen_bruto_total
FROM core.transactions;


