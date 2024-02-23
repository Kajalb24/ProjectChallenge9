WITH cte1 As (
 select   
    p.category,
    sum(`quantity_sold(before_promo)`) as quantity_before_promo,
    sum(case when  promo_type="BOGOF" then `quantity_sold(after_promo)`*2 else `quantity_sold(after_promo)` end ) as quantity_after_promo
    FROM 
        fact_events fe
    LEFT JOIN 
        dim_products p ON fe.product_code = p.product_code 
    where campaign_id ="Camp_Diw_01"
    group by category) 
SELECT  category ,
        round(((quantity_after_promo  - quantity_before_promo) /quantity_before_promo)*100,2) as ISU_percent ,
        rank() over( order by (quantity_after_promo  - quantity_before_promo) /quantity_before_promo  Desc ) as ISU_percent_rank
    FROM cte1 ;