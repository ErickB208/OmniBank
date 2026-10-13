```sql
-- Actividad: Reportes relacionales de OmniBank
-- Día 09
-- Objetivo: practicar INNER JOIN, LEFT JOIN y filtros en ON y WHERE.



SELECT COUNT(*) AS total_titulares
FROM core.customers;

SELECT COUNT(*) AS total_cuentas
FROM core.accounts;

SELECT COUNT(*) AS total_movimientos
FROM core.transactions;

-- Antes de continuar, verificar que los resultados sean
-- 4 titulares, 5 cuentas y 4 movimientos.



SELECT
    t.transaction_id,
    c.first_name,
    c.last_name,
    a.account_number,
    t.tx_type,
    t.amount
FROM core.transactions AS t
INNER JOIN core.accounts AS a
    ON t.account_id = a.account_id
INNER JOIN core.customers AS c
    ON a.customer_id = c.customer_id
ORDER BY
    t.tx_timestamp,
    t.transaction_id;



SELECT
    a.account_number,
    a.is_active,
    CASE
        WHEN a.is_active = TRUE
            THEN 'ACTIVA SIN MOVIMIENTOS'
        ELSE 'DESACTIVADA SIN MOVIMIENTOS'
    END AS estado_presentacion
FROM core.accounts AS a
LEFT JOIN core.transactions AS t
    ON a.account_id = t.account_id
WHERE t.transaction_id IS NULL
ORDER BY a.account_number;

-- ACCT-1002: cuenta desactivada sin movimientos.
-- ACCT-3002: cuenta activa sin movimientos.
-- Una cuenta desactivada no debe confundirse con una
-- cuenta activa que todavía no registra uso.


SELECT
    c.email,
    a.account_number,
    a.balance
FROM core.customers AS c
LEFT JOIN core.accounts AS a
    ON c.customer_id = a.customer_id
    AND a.balance > 0
ORDER BY
    c.email,
    a.account_number;


-- Variante incorrecta para conservar a todos los titulares:
-- al poner el filtro en WHERE, se eliminan las filas sin
-- cuenta coincidente y también las cuentas con saldo cero.

SELECT
    c.email,
    a.account_number,
    a.balance
FROM core.customers AS c
LEFT JOIN core.accounts AS a
    ON c.customer_id = a.customer_id
WHERE a.balance > 0
ORDER BY
    c.email,
    a.account_number;
