
WITH volumen_por_cuenta AS (
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
    -- Etapa 2: conservar cuentas activas sin eventos
    -- COALESCE convierte los agregados ausentes en cero
    SELECT
        a.account_id,
        a.account_number,
        a.currency,
        COALESCE(v.total_eventos, 0) AS total_eventos,
        COALESCE(v.volumen_bruto, 0) AS volumen_bruto
    FROM accounts AS a
    LEFT JOIN volumen_por_cuenta AS v
        ON a.account_id = v.account_id
    WHERE a.is_active = TRUE
),
metricas_por_moneda AS (
    -- Etapa 3: cambia el grano a una fila por moneda
    SELECT
        currency,
        COUNT(*) AS total_cuentas,
        SUM(volumen_bruto) AS volumen_bruto_total,
        ROUND(AVG(volumen_bruto), 2)
            AS promedio_por_cuenta
    FROM cuentas_activas
    GROUP BY currency
)
SELECT
    currency,
    total_cuentas,
    volumen_bruto_total,
    promedio_por_cuenta
FROM metricas_por_moneda
ORDER BY currency;

-- Comprobar el número de cuentas activas
SELECT COUNT(*) AS cuentas_activas
FROM accounts
WHERE is_active = TRUE;

-- Comprobar el volumen positivo de los movimientos
SELECT COALESCE(
    SUM(amount) FILTER (WHERE amount > 0),
    0
) AS volumen_bruto
FROM transactions;

-- Comprobar que ACCT-3002 se conserva
SELECT
    a.account_number,
    a.is_active,
    COUNT(t.transaction_id) AS total_eventos,
    COALESCE(
        SUM(t.amount) FILTER (WHERE t.amount > 0),
        0
    ) AS volumen_bruto
FROM accounts AS a
LEFT JOIN transactions AS t
    ON a.account_id = t.account_id
WHERE a.account_number = 'ACCT-3002'
GROUP BY a.account_number, a.is_active;
