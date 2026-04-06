{{ config(materialized='table') }}

select
  order_id,
  order_item_id,
  customer_id,
  product_id,
  seller_id,
  order_date,
  item_price,
  item_freight_value,
  item_gross_amount
from {{ ref('int_order_items_enriched') }}