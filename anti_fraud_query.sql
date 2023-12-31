#Fazendo análise técnica das colunas

SELECT 
  COUNT(*) AS total_rows,
  SUM(CASE WHEN transaction_id IS NULL THEN 1 ELSE 0 END) AS null_transaction_id,
  SUM(CASE WHEN merchant_id IS NULL THEN 1 ELSE 0 END) AS null_merchant_id,
  SUM(CASE WHEN user_id IS NULL THEN 1 ELSE 0 END) AS null_user_id,
  SUM(CASE WHEN card_number IS NULL THEN 1 ELSE 0 END) AS null_card_number,
  SUM(CASE WHEN transaction_date IS NULL THEN 1 ELSE 0 END) AS null_transaction_date,
  SUM(CASE WHEN transaction_amount IS NULL THEN 1 ELSE 0 END) AS null_transaction_amount,
  SUM(CASE WHEN device_id IS NULL THEN 1 ELSE 0 END) AS null_device_id,
  SUM(CASE WHEN has_cbk IS NULL THEN 1 ELSE 0 END) AS null_has_cbk
FROM `payment_analysis.transactions`;


#Chequei e filtrei as transações onde has_cbk = true e valor > 1000 entre 22 e 6 para um status Denied
#Criando uma nova view 'time_value_cbk_denied'

WITH denied AS (SELECT *,
  CASE
    WHEN has_cbk = true THEN "Denied/Has_cbk"
    WHEN (EXTRACT(HOUR FROM transaction_date) >= 22 OR EXTRACT(HOUR FROM transaction_date) < 6)
        AND transaction_amount > 1000 THEN "Denied/value"
  END AS transaction_status
FROM `winged-helper-384014.payment_analysis.transactions` )

SELECT * FROM denied
WHERE transaction_status IS NOT NULL

#Filtrei as MULTIPLAS operaçoes seguidas com diferença de tempo menor que 30 min
#Criei uma nova view 'multiple_denied'

WITH multiple_trans AS (SELECT
  transaction_id,
  merchant_id,
  user_id,
  card_number,
  transaction_date,
  transaction_amount,
  device_id,
  has_cbk,
  LAG(transaction_date) OVER (PARTITION BY card_number ORDER BY transaction_date) AS prev_transaction_time,
FROM `payment_analysis.transactions`
WHERE transaction_id NOT IN (
    SELECT transaction_id FROM `payment_analysis.time_value_cbk_denied`
  )
)

SELECT transaction_id,
  merchant_id,
  user_id,
  card_number,
  transaction_date,
  transaction_amount,
  device_id,
  has_cbk,
  "Denied/mutiple" AS transaction_status
FROM multiple_trans 
WHERE TIMESTAMP_DIFF(transaction_date, prev_transaction_time, HOUR) <= 0.5;

#Filtrei as operaçoes que estavam aprovadas e nao se encaixavam nos filtros anteriores.
#Criei uma nova view 'approved_transactions'

SELECT *
  ,"Approved" AS transaction_status
FROM `payment_analysis.transactions`
WHERE transaction_id NOT IN (
    SELECT transaction_id FROM `payment_analysis.multiple_denied`
  )
  AND transaction_id NOT IN (
    SELECT transaction_id FROM `payment_analysis.time_value_cbk_denied`
  );

#Selecionei todos os resultados e juntei em uma tabela com o status approved or denied 

SELECT transaction_id, transaction_status FROM `payment_analysis.approved_transactions`
UNION ALL
SELECT transaction_id, transaction_status FROM `payment_analysis.multiple_denied`
UNION ALL
SELECT transaction_id, transaction_status FROM `payment_analysis.time_value_cbk_denied`


