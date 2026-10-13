
SELECT
    a.account_number,
    a.is_active
FROM accounts AS a
WHERE a.is_active = TRUE
  AND NOT EXISTS (
      SELECT 1
      FROM transactions AS t
      WHERE t.account_id = a.account_id
  )
ORDER BY a.account_number;

SELECT
    a.account_number,
    a.is_active
FROM accounts AS a
WHERE NOT EXISTS (
    SELECT 1
    FROM transactions AS t
    WHERE t.account_id = a.account_id
      AND t.transaction_type = 'DEPOSIT'
)
ORDER BY a.account_number;

-- Muestra aislada: no modifica las tablas bancarias
SELECT
    7 NOT IN (1, 2, NULL) AS resultado_not_in,
    NOT EXISTS (
        SELECT 1
        FROM (VALUES (1), (2), (NULL::integer)) AS x(numero)
        WHERE x.numero = 7
    ) AS resultado_not_exists;

-- Total de cuentas activas sin movimientos
SELECT COUNT(*) AS activas_sin_movimientos
FROM accounts AS a
WHERE a.is_active = TRUE
  AND NOT EXISTS (
      SELECT 1
      FROM transactions AS t
      WHERE t.account_id = a.account_id
  );

-- Total de cuentas sin depósitos
SELECT COUNT(*) AS cuentas_sin_depositos
FROM accounts AS a
WHERE NOT EXISTS (
    SELECT 1
    FROM transactions AS t
    WHERE t.account_id = a.account_id
      AND t.transaction_type = 'DEPOSIT'
);
