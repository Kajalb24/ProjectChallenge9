WITH cte1 AS (
    SELECT 
        p.category,
        p.product_name,
        e.base_price,
        `quantity_sold(before_promo)` as quantity_before_promo,
        `quantity_sold(after_promo)` as quantity_after_promo,
        CASE
            WHEN promo_type = "50% OFF" THEN base_price * (1 - 0.50)
            WHEN promo_type = "25% OFF" THEN base_price * (1 - 0.25)
            WHEN promo_type = "BOGOF" THEN base_price * (1 - 0.50)*2
            WHEN promo_type = "500 Cashback" THEN (base_price - 500)
            WHEN promo_type = "33% OFF" THEN base_price * (1 - 0.33)
            ELSE base_price
        END AS new_promo_price
    FROM 
        fact_events e
    JOIN 
        dim_products p ON e.product_code = p.product_code
),
cte2 AS (
    SELECT 
        category,
        product_name,
        SUM(base_price * quantity_before_promo) AS before_revenue,
        SUM(new_promo_price * quantity_after_promo) AS after_revenue
    FROM 
        cte1
    GROUP BY 
        category, product_name
),
cte3 AS (
    SELECT 
        category,
        product_name,
        (after_revenue - before_revenue)/1000000 AS IR_in_millions,
     round( ((after_revenue -before_revenue)/ before_revenue)* 100,2) AS IR_per
    FROM 
        cte2
)
SELECT * , rank() over(order by IR_per DESC) as IR_rank FROM cte3 LIMIT 5 ;


