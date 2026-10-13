
SELECT
    c.account_id,
    c.account_number,
    CASE
        WHEN c.status = 'inactive' THEN 'Desactivada'
        ELSE 'Activa'
    END AS estado_cuenta,
    COUNT(t.transaction_id) AS total_movimientos
FROM Cuentas AS c
LEFT JOIN Transacciones AS t
    ON c.account_id = t.account_id
GROUP BY
    c.account_id,
    c.account_number,
    c.status
ORDER BY c.account_id;
