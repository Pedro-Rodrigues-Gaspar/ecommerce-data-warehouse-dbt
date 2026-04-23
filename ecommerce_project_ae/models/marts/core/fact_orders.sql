{{ config(materialized='table') }}

select
  order_id,
  customer_id,
  customer_unique_id,
  order_date,
  date(order_approved_datetime) as order_approved_date,
  shipped_date,
  delivered_date,
  estimated_delivery_date,
  order_status,
  order_revenue,
  order_freight_value,
  order_gross_amount,
  nb_product_items as nb_items,
  nb_sellers,
  case
    when delivered_date is not null
    then date_diff(delivered_date, order_date, day)
  end as delivery_delay_days
from {{ ref('int_orders_enriched') }}