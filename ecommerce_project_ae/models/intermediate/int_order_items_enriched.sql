{{ config(materialized='view') }}

select
    oi.order_id,
    oi.order_item_id,
    o.customer_id,
    oi.product_id,
    oi.seller_id,
    p.product_category_name,
    pc.product_category_name_english,
    oi.price as item_price,
    oi.freight_value as item_freight_value,
    oi.price + oi.freight_value as item_gross_amount,
    o.order_date,
    o.order_status,
    s.seller_city,
    s.seller_state
from {{ source('ecommerce_analytics', 'stg_order_items') }} oi
left join {{ source('ecommerce_analytics', 'stg_orders') }} o
    on oi.order_id = o.order_id
left join {{ source('ecommerce_analytics', 'stg_products') }} p
    on oi.product_id = p.product_id
left join {{ source('ecommerce_analytics', 'stg_product_category_name') }} pc
    on p.product_category_name = pc.product_category_name
left join {{ source('ecommerce_analytics', 'stg_sellers') }} s
    on oi.seller_id = s.seller_id