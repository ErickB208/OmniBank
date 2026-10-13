```sql
-- Actividad: Diagnóstico de combinaciones sin relación en OmniBank
-- Día 09
-- Objetivo: comparar un producto cartesiano con un JOIN correcto.



SELECT
    (SELECT COUNT(*) FROM core.customers) AS total_titulares,
    (SELECT COUNT(*) FROM core.accounts) AS total_cuentas,
    (SELECT COUNT(*) FROM core.transactions) AS total_movimientos,
    (
        SELECT COUNT(*)
        FROM core.customers AS c
        CROSS JOIN core.accounts AS a
        CROSS JOIN core.transactions AS t
    ) AS total_combinaciones;



SELECT
    c.email,
    a.account_number,
    t.tx_type,
    t.amount,
    t.tx_timestamp
FROM core.transactions AS t
INNER JOIN core.accounts AS a
    ON t.account_id = a.account_id
INNER JOIN core.customers AS c
    ON a.customer_id = c.customer_id
WHERE
    c.is_active = TRUE
    AND t.amount >= 100
ORDER BY
    t.tx_timestamp,
    t.transaction_id;

