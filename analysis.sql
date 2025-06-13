-- Query RFM + Segmentasi pelanggan

SELECT
    customer_id,
    recency_scores,
    frequency_scores,
    monetary_scores,
    R,
    F,
    M,
    CASE
    	-- Segmentasi pelanggan berdasarkan RFM
        WHEN R = 4 AND F = 4 AND M = 4 THEN 'Champions'
        WHEN R = 4 AND F = 4 THEN 'Loyal Customers'
        WHEN F = 4  AND M = 4 THEN 'Big Spenders'
        
        WHEN R = 3 AND F = 3 AND M = 3 THEN 'High Potential'
        WHEN R = 3 AND F = 3 THEN 'High Activity'
        WHEN F = 3 AND M = 3 THEN 'High Spending'
        
        WHEN R = 2 AND F = 2 AND M = 2 THEN 'Promising'
        WHEN R = 2 AND F = 2 THEN 'Active'
        WHEN F = 2 AND M = 2 THEN 'Spenders'
        
        WHEN R = 1 AND F = 1 AND M = 1 THEN 'Needs Attention'
        WHEN R = 1 AND F = 1 THEN 'Inactive'
        WHEN F = 1 AND M = 1 THEN 'Low Spending'
        ELSE 'Others'
    END AS customer_segment
FROM (
    -- Subquery skor RFM 1-4 (Semakin tinggi semakin baik)
    SELECT
        customer_id,
        recency_scores,
        frequency_scores,
        monetary_scores,
        NTILE(4) OVER (ORDER BY recency_scores DESC) AS R,
        NTILE(4) OVER (ORDER BY frequency_scores ASC) AS F,
        NTILE(4) OVER (ORDER BY monetary_scores ASC) AS M
    FROM (
        -- Subquery menghitung skor RFM mentah
        SELECT
            customer_id,
            DATEDIFF('2025-05-06', MAX(order_date)) AS recency_scores,
            COUNT(order_id) AS frequency_scores,
            SUM(payment_value) AS monetary_scores
        FROM
            e_commerce_transactions
        GROUP BY
            customer_id
    ) AS raw_rfm
) AS rfm_scores  
ORDER BY CAST(`rfm_scores`.`customer_id` AS UNSIGNED) ASC;

-- Query repeat-purchase bulanan

WITH MonthlyCustomerTransactions AS (
    -- Hitung jumlah transaksi untuk setiap pelanggan per bulan
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS transaction_month,
        customer_id,
        COUNT(order_id) AS total_transactions
    FROM
        e_commerce_transactions
    GROUP BY
        transaction_month,
        customer_id
)
-- Kelompokkan berdasarkan bulan dan hitung setiap metrik
SELECT
    transaction_month,
    SUM(CASE WHEN total_transactions = 1 THEN 1 ELSE 0 END) AS single_purchase_customers,
    SUM(CASE WHEN total_transactions > 1 THEN 1 ELSE 0 END) AS repeat_customers,
    COUNT(customer_id) AS total_unique_customers,
    (SUM(CASE WHEN total_transactions > 1 THEN 1 ELSE 0 END) / COUNT(customer_id)) * 100 AS repeat_purchase_rate_pct
FROM
    MonthlyCustomerTransactions
GROUP BY
    transaction_month
ORDER BY
    transaction_month;

