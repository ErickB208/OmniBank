
SELECT
    COUNT(*) AS total_cuentas,
    COUNT(*) FILTER (
        WHERE status = 'inactive'
    ) AS cuentas_desactivadas,
    ROUND(
        COUNT(*) FILTER (
            WHERE status = 'inactive'
        )::numeric
        / NULLIF(COUNT(*), 0) * 100,
        2
    ) AS porcentaje_desactivadas
FROM accounts;
