{{ config(materialized='view') }}

select 
  o.order_id,
  o.customer_id,
  o.order_status,
  o.order_date,
  c.city as customer_city,
  c.state as customer_state,
  o.order_approved_datetime,
  o.shipped_date,
  o.delivered_date,
  o.estimated_delivery_date,
  coalesce(sum(oi.item_price), 0) as order_revenue,
  coalesce(sum(oi.item_freight_value), 0) as order_freight_value,
  coalesce(sum(oi.item_gross_amount), 0) as order_gross_amount,
  count(oi.order_item_id) as nb_product_items,
  count(distinct oi.seller_id) as nb_sellers
from `ecommerce_analytics.stg_orders` as o
left join `ecommerce_analytics.int_order_items_enriched` as oi
  on o.order_id = oi.order_id
left join `ecommerce_analytics.stg_customers` as c
  on o.customer_id = c.customer_id
group by 1,2,3,4,5,6,7,8,9,10