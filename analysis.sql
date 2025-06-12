SELECT
    customer_id,
    recency_scores,
    frequency_scores,
    monetary_scores,
    R,
    F,
    M,
    CASE
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
    SELECT
        customer_id,
        recency_scores,
        frequency_scores,
        monetary_scores,
        NTILE(4) OVER (ORDER BY recency_scores DESC) AS R,
        NTILE(4) OVER (ORDER BY frequency_scores ASC) AS F,
        NTILE(4) OVER (ORDER BY monetary_scores ASC) AS M
    FROM (
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
ORDER BY `rfm_scores`.`customer_id` ASC