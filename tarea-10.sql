
WITH muestra AS (
    SELECT 10000::NUMERIC AS valor
    UNION ALL
    SELECT 0::NUMERIC
    UNION ALL
    SELECT 0::NUMERIC
    UNION ALL
    SELECT NULL::NUMERIC
)
SELECT
    AVG(valor) AS promedio_sin_coalesce,
    COUNT(valor) AS observaciones_sin_coalesce,
    AVG(COALESCE(valor, 0)) AS promedio_con_coalesce,
    COUNT(COALESCE(valor, 0)) AS observaciones_con_coalesce
FROM muestra;


SELECT
    a.account_number,
    a.balance AS saldo_almacenado,
    COUNT(t.transaction_id) AS cantidad_movimientos,
    COALESCE(SUM(t.amount), 0) AS volumen_bruto_registrado
FROM core.accounts AS a
LEFT JOIN core.transactions AS t
    ON a.account_id = t.account_id
WHERE
    a.account_type = 'CREDIT'
    AND a.is_active = TRUE
GROUP BY
    a.account_id,
    a.account_number,
    a.balance
HAVING
    COUNT(t.transaction_id) = 0
    OR COALESCE(SUM(t.amount), 0) >= 300
ORDER BY
    a.account_number;