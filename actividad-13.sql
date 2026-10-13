
WITH metricas_movimientos AS (
    -- Etapa 1: una fila por cuenta con movimientos
    SELECT
        t.account_id,
        COUNT(*) AS total_eventos,
        SUM(t.amount) FILTER (
            WHERE t.amount > 0
        ) AS volumen_bruto
    FROM transactions AS t
    GROUP BY t.account_id
),
cuentas_activas AS (
    -- Etapa 2: conservar todas las cuentas activas
    SELECT
        a.account_id,
        a.account_number,
        a.customer_id,
        a.currency,
        COALESCE(m.total_eventos, 0) AS total_eventos,
        COALESCE(m.volumen_bruto, 0) AS volumen_bruto
    FROM accounts AS a
    LEFT JOIN metricas_movimientos AS m
        ON a.account_id = m.account_id
    WHERE a.is_active = TRUE
),
reporte_titulares AS (
    -- Etapa 3: agregar los datos del titular
    SELECT
        ca.account_id,
        ca.account_number,
        cu.name AS titular,
        ca.currency,
        ca.total_eventos,
        ca.volumen_bruto,
        CASE
            WHEN ca.total_eventos = 0 THEN 'Sin actividad'
            WHEN ca.total_eventos = 1 THEN 'Baja'
            WHEN ca.total_eventos = 2 THEN 'Media'
            ELSE 'Alta'
        END AS banda_actividad
    FROM cuentas_activas AS ca
    INNER JOIN customers AS cu
        ON ca.customer_id = cu.customer_id
)
SELECT
    account_id,
    account_number,
    titular,
    currency,
    total_eventos,
    volumen_bruto,
    banda_actividad
FROM reporte_titulares
ORDER BY account_number;

-- Comprobar cuántas cuentas están activas
SELECT COUNT(*) AS total_cuentas_activas
FROM accounts
WHERE is_active = TRUE;

-- Comprobar el volumen bruto de los movimientos
SELECT
    COALESCE(
        SUM(amount) FILTER (WHERE amount > 0),
        0
    ) AS volumen_bruto_total
FROM transactions;
