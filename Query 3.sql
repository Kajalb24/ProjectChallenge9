select campaign_name,
 round( sum(base_price * `quantity_sold(before_promo)`)/1000000,2) as total_revenue_before_promo,
Round( sum(case 
 when promo_type = '25% OFF' then base_price * 0.75 * fe.`quantity_sold(after_promo)`
when promo_type = '33% OFF' then base_price * 0.67 * fe.`quantity_sold(after_promo)`
when promo_type = '50% OFF' then base_price * 0.50 *fe.`quantity_sold(after_promo)`
when promo_type = '500 Cashback' then (base_price - 500) * fe.`quantity_sold(after_promo)`
when promo_type = 'BOGOF' then base_price * 0.50 * fe.`quantity_sold(after_promo)`*2
else base_price * fe.`quantity_sold(after_promo)`
end
) / 1000000 ,2 ) as total_revenue_after_promo from fact_events as fe  join dim_campaigns
on dim_campaigns.campaign_id = fe.campaign_id
group by campaign_name 
 