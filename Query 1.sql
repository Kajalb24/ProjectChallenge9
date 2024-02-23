Select distinct( p.product_code), p.category, p.product_name
from dim_products p join fact_events f on 
p.product_code = f.product_code
where base_price> 500 and promo_type="BOGOF"