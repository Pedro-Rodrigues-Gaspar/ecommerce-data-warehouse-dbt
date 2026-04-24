{{ config(materialized='table') }}

select distinct
  p.product_id,
  p.product_category_name,
  pc.product_category_name_english
from {{ source('ecommerce_analytics', 'stg_products') }} as p
left join {{ source('ecommerce_analytics', 'stg_product_category_name') }} as pc
  on pc.product_category_name = p.product_category_name