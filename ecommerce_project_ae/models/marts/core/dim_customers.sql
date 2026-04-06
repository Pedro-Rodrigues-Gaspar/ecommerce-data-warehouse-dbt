{{ config(materialized='table') }}

select distinct
  customer_id,
  customer_unique_id,
  city as customer_city,
  state as customer_state
from `ecommerce_analytics.stg_customers`